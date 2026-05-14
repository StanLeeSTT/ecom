# LEGIMI COMMERCE — ARCHITECTURE GUIDE

## System Architecture

### Layered Architecture

```
┌─────────────────────────────────────────┐
│        Frontend Layer (Next.js)          │
│  ├─ Web Dashboard                       │
│  ├─ Admin Panel                         │
│  └─ Storefront (Customer-facing)        │
├─────────────────────────────────────────┤
│     GraphQL Gateway / API Layer          │
│  ├─ Authentication Middleware           │
│  ├─ Rate Limiting                       │
│  └─ Request/Response Transformation     │
├─────────────────────────────────────────┤
│      Domain Services (NestJS/Go)        │
│  ├─ Auth Service                        │
│  ├─ Product Service                     │
│  ├─ Order Service                       │
│  ├─ AI Agent Service                    │
│  ├─ Analytics Service                   │
│  └─ ... other services                  │
├─────────────────────────────────────────┤
│      Data Layer & External Services     │
│  ├─ PostgreSQL (Primary store)          │
│  ├─ Redis (Cache/Sessions)              │
│  ├─ OpenSearch (Full-text search)       │
│  ├─ S3 (File storage)                   │
│  ├─ AI APIs (OpenAI, Claude, Gemini)    │
│  └─ Payment Processors (Stripe, etc)    │
└─────────────────────────────────────────┘
```

### Microservices Pattern

Each domain service:
- **Owns its database schema** (no shared databases)
- **Exposes GraphQL queries/mutations**
- **Publishes domain events** (async communication)
- **Implements RBAC** within domain
- **Has dedicated Redis cache**

### Event-Driven Architecture

Services communicate via event bus:

```
Auth Service
    ↓ publishes: UserCreated, UserAuthenticated
    ↓
Order Service ← subscribes to: UserCreated
Analytics Service ← subscribes to: OrderPlaced, PaymentProcessed
NotificationService ← subscribes to: OrderStatus
```

## Key Design Principles

### 1. Modularity
- Services are independently deployable
- Packages are independently testable
- Components are composable

### 2. Scalability
- Stateless services (all state in PostgreSQL/Redis)
- Horizontal scaling ready
- Database indexes optimized

### 3. Type Safety
- TypeScript strict mode everywhere
- Zod for runtime validation
- GraphQL schema as source of truth

### 4. Performance
- Caching strategies (Redis, browser)
- Database query optimization
- Image optimization pipeline
- Code splitting & lazy loading

### 5. AI-First
- AI models as first-class services
- Vector embeddings for semantic search
- LLM agents for autonomous operations
- Observability for AI model behavior

### 6. Security
- RBAC at service level
- Encrypted secrets management
- Rate limiting on APIs
- Audit logging for compliance

## Data Models

### Core Entities

```
Organization
├─ Store
│  ├─ Products
│  ├─ Orders
│  ├─ Customers
│  └─ Analytics
├─ Users (with roles)
├─ Workflows
└─ AI Configurations

Store
├─ Theme & Branding
├─ Pages
├─ Collections
└─ Settings

Product
├─ Variants
├─ Media
├─ SEO Metadata
└─ AI Descriptions

Order
├─ Items
├─ Customer
├─ Payment
├─ Fulfillment
└─ Timeline
```

## API Structure

### GraphQL Gateway

```graphql
# Example structure
type Query {
  # Auth
  me: User
  
  # Store
  store(id: ID!): Store
  stores(first: 10): StoreConnection
  
  # Products
  products(first: 20, filter: ProductFilter): ProductConnection
  
  # Orders
  orders(first: 20, filter: OrderFilter): OrderConnection
  
  # Analytics
  analytics(dateRange: DateRange!): Analytics
}

type Mutation {
  # Auth
  signUp(input: SignUpInput!): AuthPayload
  signIn(input: SignInInput!): AuthPayload
  
  # Store
  createStore(input: CreateStoreInput!): Store
  updateStore(input: UpdateStoreInput!): Store
  
  # Products
  createProduct(input: CreateProductInput!): Product
  updateProduct(input: UpdateProductInput!): Product
  
  # AI
  generateStore(input: GenerateStoreInput!): Store
  refineDesign(input: RefineDesignInput!): Design
}
```

## State Management

### Server State (TanStack Query)
- Fetched data, caching, synchronization
- Automatic invalidation

### Client State (Zustand)
- UI state (modals, filters, page state)
- User preferences
- Real-time updates from WebSocket

### Optimistic UI
- Immediate UI updates before server confirmation
- Rollback on error

## Deployment Architecture

### Development
- Local PostgreSQL + Redis (Docker)
- pnpm monorepo
- Hot-reload all services

### Staging
- Railway backend
- Vercel frontend
- Supabase database

### Production
- Kubernetes cluster
- Managed PostgreSQL
- Managed Redis
- CDN caching

## Observability

### Logging
- Structured JSON logging
- Centralized log aggregation
- Log levels: debug, info, warn, error

### Metrics
- Request latency
- Error rates
- Database query performance
- Cache hit rates
- AI model response times

### Tracing
- Distributed tracing (OpenTelemetry)
- Request correlation IDs
- Service-to-service tracing

### Monitoring
- Real-time dashboards
- Alerting on anomalies
- AI-driven insights

## Naming Conventions

### Directories
- `/src` — Source code
- `/lib` — Shared utilities
- `/types` — TypeScript types
- `/hooks` — React hooks
- `/components` — React components
- `/services` — Business logic
- `/utils` — Helper functions
- `/constants` — Constants

### Files
- Components: `PascalCase.tsx`
- Utilities: `camelCase.ts`
- Types: `camelCase.types.ts`
- Tests: `camelCase.test.ts`
- Styles: `camelCase.module.css`

### Variables & Functions
- Constants: `UPPER_CASE`
- Functions/variables: `camelCase`
- React components: `PascalCase`
- Types/interfaces: `PascalCase`

## Performance Targets

- **Page Load**: < 2s (LCP)
- **First Input Delay**: < 100ms
- **Cumulative Layout Shift**: < 0.1
- **API Response**: < 200ms (p95)
- **Database Query**: < 50ms (p95)

## Testing Strategy

### Unit Tests (Vitest)
- Business logic
- Utilities
- Hooks

### Integration Tests
- Service interactions
- Database queries
- API endpoints

### E2E Tests (Playwright)
- Critical user flows
- Store generation
- Checkout process

### Visual Tests
- Component library
- Page layouts
- Responsive design

## Dependencies Strategy

### Frontend
- Minimize dependencies (tree-shaking)
- Prefer native APIs when possible
- Pin versions for stability

### Backend
- Modular services (loose coupling)
- Vendor-agnostic where possible
- Use monorepo path resolution

## Security Architecture

### Authentication
- JWT tokens (short-lived)
- Refresh tokens (long-lived)
- Session cookies (httpOnly)

### Authorization
- RBAC at API level
- Row-level security in database
- Feature flags for gradual rollout

### Data Protection
- Encryption at rest (PG with pgcrypto)
- Encryption in transit (HTTPS/TLS)
- PII redaction in logs

### Infrastructure
- VPC for services
- Secrets management (encrypted)
- DDoS protection (Cloudflare)
