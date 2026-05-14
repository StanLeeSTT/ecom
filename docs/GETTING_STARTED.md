# GETTING STARTED — LEGIMI COMMERCE

## Prerequisites

Before starting, ensure you have installed:

- **Node.js** 20+ ([download](https://nodejs.org/))
- **pnpm** 8+ (`npm install -g pnpm`)
- **Docker** & **Docker Compose** ([download](https://www.docker.com/))
- **PostgreSQL** 15+ (or use Docker)
- **Redis** 7+ (or use Docker)
- **Git**

## Quick Start

### 1. Clone & Install

```bash
cd ~/Desktop/ecom
pnpm install
```

### 2. Start Services

```bash
# Start PostgreSQL, Redis, OpenSearch, MinIO
docker-compose up -d

# Verify services
docker-compose ps

# Should show:
# - legimi-postgres (running)
# - legimi-redis (running)
# - legimi-opensearch (running)
# - legimi-minio (running)
```

### 3. Setup Database

```bash
# Create environment file
cp .env.example .env.local

# Run migrations
pnpm db:migrate
```

### 4. Start Development Servers

**Terminal 1 — API Server:**
```bash
cd apps/api
pnpm dev
# Server running at http://localhost:3001
# GraphQL Playground at http://localhost:3001/graphql
```

**Terminal 2 — Web Dashboard:**
```bash
cd apps/web
pnpm dev
# Running at http://localhost:3000
```

**Terminal 3 — Storefront:**
```bash
cd apps/storefront
pnpm dev
# Running at http://localhost:3002
```

## Environment Variables

Create `.env.local` at the project root:

```env
# Database
DATABASE_URL=postgresql://legimi_dev:legimi_dev_password@localhost:5432/legimi_commerce
SHADOW_DATABASE_URL=postgresql://legimi_dev:legimi_dev_password@localhost:5432/legimi_commerce_shadow

# Redis
REDIS_URL=redis://localhost:6379

# OpenSearch
OPENSEARCH_URL=http://localhost:9200
OPENSEARCH_PASSWORD=LegimI@2024

# S3 / MinIO
S3_ENDPOINT=http://localhost:9000
S3_ACCESS_KEY=minioadmin
S3_SECRET_KEY=minioadmin
S3_BUCKET=legimi-bucket

# API Keys
JWT_SECRET=your-secret-key-change-in-production
OPENAI_API_KEY=sk-...
STRIPE_SECRET_KEY=sk_test_...

# Frontend URLs
NEXT_PUBLIC_API_URL=http://localhost:3001
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

## Project Structure Quick Reference

```
/apps/web          → Main dashboard & admin panel
/apps/api          → GraphQL API server (NestJS)
/apps/storefront   → Customer-facing store

/packages/auth     → Authentication system
/packages/database → Prisma ORM & migrations
/packages/ui       → React components
/packages/ai       → AI agent orchestration
/packages/utils    → Shared utilities

/docs              → Documentation
/infrastructure    → Docker, K8s, Terraform
```

## Common Commands

### Install Dependencies
```bash
# Install all dependencies
pnpm install

# Install specific package
pnpm add package-name
```

### Type Checking
```bash
pnpm type-check
```

### Linting & Formatting
```bash
pnpm lint
pnpm format
```

### Running Tests
```bash
pnpm test
pnpm test:watch
pnpm test:cov
```

### Database
```bash
# Run migrations
pnpm db:migrate

# Create new migration
pnpm db:migration create

# Reset database (careful!)
pnpm db:reset

# Seed database
pnpm db:seed
```

## Accessing Services

| Service | URL | Credentials |
|---------|-----|-------------|
| Web Dashboard | http://localhost:3000 | — |
| GraphQL Playground | http://localhost:3001/graphql | — |
| Storefront | http://localhost:3002 | — |
| MinIO Console | http://localhost:9001 | minioadmin / minioadmin |
| OpenSearch | http://localhost:9200 | admin / LegimI@2024 |
| PostgreSQL | localhost:5432 | legimi_dev / legimi_dev_password |
| Redis | localhost:6379 | — |

## Troubleshooting

### Port Already in Use

```bash
# Find process using port 3000
lsof -i :3000

# Kill process
kill -9 <PID>
```

### Docker Services Not Starting

```bash
# Check logs
docker-compose logs postgres

# Restart services
docker-compose restart

# Full rebuild
docker-compose down
docker-compose up -d
```

### Database Connection Error

```bash
# Verify PostgreSQL is running
docker-compose ps postgres

# Check logs
docker-compose logs postgres

# Recreate database
docker-compose down postgres
docker volume rm ecom_postgres_data
docker-compose up -d postgres
```

### pnpm Issues

```bash
# Clear cache
pnpm store prune

# Reinstall dependencies
rm -rf node_modules pnpm-lock.yaml
pnpm install
```

## Next Steps

1. ✅ Start development servers
2. 📖 Read [ARCHITECTURE.md](./ARCHITECTURE.md)
3. 📋 Read [DEVELOPMENT.md](./DEVELOPMENT.md)
4. 🔨 Start building Phase 1 systems

## API Documentation

API endpoint documentation will be auto-generated in GraphQL Playground once the API server is running.

## Design System

Component documentation and Storybook coming soon.

## Getting Help

- 📚 Read [ARCHITECTURE.md](./ARCHITECTURE.md) for system design
- 🔍 Check [DEVELOPMENT.md](./DEVELOPMENT.md) for coding standards
- 📋 Review individual package READMEs
- 🐛 Check existing issues on GitHub

## Performance Tips

- Use `pnpm` instead of `npm` (faster)
- Keep `docker-compose` running in background
- Use `pnpm dev` for hot-reload during development
- Run `pnpm type-check` frequently for early error detection

---

**Happy coding!** 🚀

Remember: Every feature must align with the master plan. When in doubt, revisit [LEGIMI_MASTER_PLAN.md](/memories/repo/LEGIMI_MASTER_PLAN.md).
