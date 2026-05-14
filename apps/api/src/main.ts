import { NestFactory } from '@nestjs/core'
import { AppModule } from './app.module'

async function bootstrap() {
  const app = await NestFactory.create(AppModule)

  // CORS
  app.enableCors()

  // Global prefix
  app.setGlobalPrefix('api')

  const port = process.env.PORT || 3001
  await app.listen(port)
  console.log(`🚀 API Server running on http://localhost:${port}`)
  console.log(`📊 GraphQL Playground at http://localhost:${port}/graphql`)
}

bootstrap()
