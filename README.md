# LEGIMI COMMERCE

**AI-native commerce operating system** — compete with Shopify with fundamentally superior AI-first architecture, modern UX, cinematic design, and autonomous workflows.

**Built with completely FREE AI, Supabase database, and ready for GitHub deployment!**

## 🎯 Core Mission

Build a world-class commerce infrastructure that feels:
- **Premium** — Linear, Stripe, Framer, Vercel combined
- **Futuristic** — Cinematic, alive, intelligent
- **Autonomous** — AI agents orchestrating commerce operations
- **Instant** — Fast, responsive, optimized conversions

## ⚡ Quick Start (30 minutes)

```bash
cd ~/Desktop/ecom
bash scripts/setup.sh
```

See [QUICK_START.md](QUICK_START.md) for step-by-step guide.

## 📁 Project Structure

```
legimi-commerce/
├── apps/                    # Core applications
│   ├── web/                 # Main dashboard & admin
│   ├── admin/               # Admin panel
│   ├── storefront/          # Customer-facing store
│   └── api/                 # NestJS/Go backend
├── packages/                # Reusable modules
│   ├── ui/                  # Component library
│   ├── design-system/       # Design tokens & themes
│   ├── ai/                  # AI agents & orchestration
│   ├── auth/                # Authentication system
│   ├── database/            # Database layer (Prisma)
│   ├── workflows/           # Automation workflows
│   ├── analytics/           # Analytics engine
│   ├── payments/            # Payment processing
│   ├── checkout/            # Checkout engine
│   ├── search/              # Semantic search
│   ├── email/               # Email templates & service
│   └── utils/               # Utilities & helpers
├── infrastructure/          # Deployment & DevOps
│   ├── docker/              # Docker configurations
│   ├── k8s/                 # Kubernetes manifests
│   └── terraform/           # Infrastructure as Code
├── docs/                    # Documentation
└── scripts/                 # Build & automation scripts
```

## 🛠 Tech Stack

### Frontend
- **Next.js** — React framework with SSR/SSG
- **TypeScript** — Strict mode for type safety
- **TailwindCSS** — Utility-first styling
- **Framer Motion** — Production animation library
- **Zustand** — State management
- **TanStack Query** — Server state management
- **React Hook Form** — Form handling
- **Zod** — Schema validation
- **Shadcn UI** — Customizable component library

### Backend
- **NestJS/Go** — Microservices architecture
- **GraphQL** — Unified API gateway
- **Supabase** — PostgreSQL database (free tier)
- **Redis** — Caching & real-time features (optional)
- **OpenSearch** — Full-text search (optional)

### AI & Automation (All FREE!)
- **Groq API** — Fastest free LLM
- **Hugging Face** — 30k API calls/month free
- **Ollama** — Local LLM (completely free)
- **Replicate** — ML models, image generation
- **Stability AI** — Image generation
- **Together AI** — Free LLM inference

### Infrastructure
- **Docker** — Containerization
- **Kubernetes** — Orchestration (ready)
- **Vercel** — Frontend hosting (free)
- **Railway** — Backend hosting (free)
- **Supabase** — Database hosting (free)

## 💰 Pricing: COMPLETELY FREE

| Component | Cost | Free Tier |
|-----------|------|-----------|
| **Frontend Hosting** | Vercel | ∞ projects |
| **Backend Hosting** | Railway | 5GB/month |
| **Database** | Supabase | 8GB storage |
| **AI - Groq** | FREE | Unlimited |
| **AI - Hugging Face** | FREE* | 30k calls/month |
| **AI - Ollama** | FREE | Local, unlimited |
| **Repository** | GitHub | Unlimited |
| **Email** | Resend/Brevo | 100+ emails/day |
| **Total Cost** | **$0/month** | ✅ Completely FREE |

\* Replicate ($40/mo credits), Stability ($25/mo credits)

## 📋 14 Master Systems

### Phase 1 (MVP)
1. **Authentication** — Signup, OAuth, RBAC, audit logs
2. **AI Store Generator** — Prompt to store generation
3. **Visual Page Builder** — Drag/drop editor with live preview
4. **Design System** — Typography, spacing, colors, animations
5. **Product Engine** — Products, variants, collections, AI features
6. **Checkout Engine** — Express checkout, payment processing
7. **Payments** — Stripe, Apple Pay, Google Pay integration
8. **Hosting & Deployment** — One-click store deployment
9. **Analytics** — Real-time dashboards with AI insights

### Phase 2
10. **AI Agents** — Autonomous operations (SEO, marketing, pricing)
11. **Automation Engine** — Visual workflows and triggers
12. **CMS** — Blogs, landing pages, SEO optimization
13. **Search Engine** — Semantic search with recommendations
14. **App Marketplace** — Third-party integrations

### Phase 3
- Enterprise systems, fulfillment, omnichannel commerce

## 🚀 Getting Started

### Prerequisites
- Node.js 20+
- pnpm 8+
- PostgreSQL 15+
- Redis 7+

### Installation

```bash
# Clone repository
git clone https://github.com/legimi/commerce.git
cd legimi-commerce

# Install dependencies
pnpm install

# Setup environment
cp .env.example .env.local

# Run development servers
pnpm dev
```

## � Documentation

- **[QUICK_START.md](QUICK_START.md)** ⭐ Start here! (30 min setup)
- [FREE_AI_INTEGRATION.md](docs/FREE_AI_INTEGRATION.md) — Setup 6 free AI services
- [SUPABASE_SETUP.md](docs/SUPABASE_SETUP.md) — Free database & auth
- [GITHUB_DEPLOYMENT.md](docs/GITHUB_DEPLOYMENT.md) — Deploy to GitHub, Vercel, Railway
- [GETTING_STARTED.md](docs/GETTING_STARTED.md) — Local development setup
- [ARCHITECTURE.md](docs/ARCHITECTURE.md) — System design & patterns
- [DEVELOPMENT.md](docs/DEVELOPMENT.md) — Code standards & workflow
- [ROADMAP.md](docs/ROADMAP.md) — Implementation timeline

## ✨ Design Philosophy

Every UI must include:
- ✅ Micro-interactions & spring physics
- ✅ Smooth page transitions
- ✅ Loading & skeleton states
- ✅ Error state handling
- ✅ Accessibility (keyboard, screen readers)
- ✅ Responsive design (mobile, tablet, desktop)
- ✅ Dark mode support
- ✅ Optimistic UI updates

Animations should feel:
- Intentional (purposeful motion)
- Physical (spring-based)
- Smooth (60fps minimum)
- Elegant (subtle, not excessive)

## 📚 Documentation

- [Architecture Guide](./docs/ARCHITECTURE.md)
- [Database Schema](./docs/DATABASE.md)
- [API Documentation](./docs/API.md)
- [Component Library](./docs/COMPONENTS.md)
- [Deployment Guide](./docs/DEPLOYMENT.md)

## 🔐 Security

- CSRF protection
- XSS prevention
- Rate limiting
- Encrypted secrets
- Audit logging
- RBAC enforcement

## 📊 Development Status

Currently in **Phase 1 Setup**.

- ✅ Monorepo structure
- ✅ TypeScript configuration
- ⏳ Authentication system
- ⏳ AI store generator
- ⏳ Visual page builder

## 🤝 Contributing

This is an internal project. See [CONTRIBUTING.md](./docs/CONTRIBUTING.md) for guidelines.

## 📄 License

Proprietary — All rights reserved.

---

**Remember**: This is not a basic ecommerce platform. This is AI commerce infrastructure designed to redefine the future of entrepreneurship.
