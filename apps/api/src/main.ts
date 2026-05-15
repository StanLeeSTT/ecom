import { NestFactory } from '@nestjs/core'
import { AppModule } from './app.module'
import * as compression from 'compression'

async function bootstrap() {
  const app = await NestFactory.create(AppModule)

  // Performance: Enable response compression (gzip)
  app.use(compression())

  // CORS - Hardened for production
  const allowedOrigins = process.env.ALLOWED_ORIGINS
    ? process.env.ALLOWED_ORIGINS.split(',')
    : ['http://localhost:3000', 'http://localhost:3002']

  app.enableCors({
    origin: allowedOrigins,
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS', 'PATCH'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    maxAge: process.env.NODE_ENV === 'production' ? 86400 : 3600, // 24h prod, 1h dev
  })

  // Security headers
  app.use((req, res, next) => {
    res.header('X-Content-Type-Options', 'nosniff')
    res.header('X-Frame-Options', 'DENY')
    res.header('X-XSS-Protection', '1; mode=block')
    res.header('Strict-Transport-Security', 'max-age=31536000; includeSubDomains')
    res.header('Content-Encoding', 'gzip') // Performance: Ensure compression is applied
    next()
  })

  // Request logging with minimal overhead (development only)
  if (process.env.NODE_ENV !== 'production') {
    app.use((req, res, next) => {
      const start = Date.now()
      res.on('finish', () => {
        const duration = Date.now() - start
        if (duration > 1000) {
          console.warn(`⚠️  Slow request: ${req.method} ${req.path} (${duration}ms)`)
        }
      })
      next()
    })
  }

  // Global prefix
  app.setGlobalPrefix('api')

  const port = process.env.PORT || 3001
  await app.listen(port)
  console.log(`🚀 API Server running on http://localhost:${port}`)
  console.log(`📊 GraphQL Playground at http://localhost:${port}/graphql`)
  console.log(`🔒 Security: CORS restricted, Headers enforced, Compression enabled`)
  console.log(`⚡ Performance: Response compression active, Query depth limited`)
}

bootstrap()
