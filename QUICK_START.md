# 🚀 LEGIMI COMMERCE — FULL DETAILED LAUNCH INSTRUCTIONS

### 1. Prerequisites

- Node.js 20+ and pnpm 8+ ([Install Node.js](https://nodejs.org/), [Install pnpm](https://pnpm.io/installation))
- Docker Desktop ([Install Docker](https://www.docker.com/products/docker-desktop/))
- GitHub account ([Sign up](https://github.com/join))
- Free accounts for: [Groq](https://console.groq.com/keys), [Hugging Face](https://huggingface.co/settings/tokens), [Replicate](https://replicate.com/account/api-tokens), [Supabase](https://app.supabase.com), [Vercel](https://vercel.com), [Railway](https://railway.app)

---

### 2. Clone the Repository

```bash
git clone https://github.com/StanLeeSTT/ecom.git
cd ecom
```

---

### 3. Install Dependencies

```bash
pnpm install
```

---

### 4. Set Up Environment Variables

```bash
cp .env.example .env.local
# Open .env.local and fill in:
# - GROQ_API_KEY
# - HUGGING_FACE_API_KEY
# - REPLICATE_API_KEY
# - SUPABASE_URL
# - SUPABASE_ANON_KEY
# - SUPABASE_SERVICE_KEY
# (See FREE_AI_INTEGRATION.md and SUPABASE_SETUP.md for details)
```

---

### 5. Start Local Development (Optional, for testing before deploy)

```bash
# Start Docker services (Postgres, Redis, etc.)
docker-compose up -d

# Start backend API
cd apps/api && pnpm dev
# In a new terminal, start web dashboard
cd ../web && pnpm dev
# In another terminal, start storefront
cd ../storefront && pnpm dev
```

Visit:
- Dashboard: http://localhost:3000
- Storefront: http://localhost:3002
- API: http://localhost:3001/graphql

---

### 6. Push Code to GitHub

```bash
git add .
git commit -m "Initial commit: LEGIMI Commerce (free AI, Supabase, deploy-ready)"
git remote add origin https://github.com/StanLeeSTT/ecom.git
git branch -M main
git push -u origin main
```

---

### 7. Deploy Backend to Railway

1. Go to [Railway](https://railway.app)
2. Click **New Project** → **Deploy from GitHub**
3. Select your `ecom` repository
4. Add a new **Service** → **Docker** (choose `apps/api/Dockerfile`)
5. Set environment variables (copy from `.env.local`)
6. Click **Deploy**
7. After deploy, copy your Railway API URL (e.g. `https://your-api-production.up.railway.app`)

---

### 8. Deploy Frontend to Vercel

1. Go to [Vercel](https://vercel.com)
2. Click **Import Project**
3. Select **GitHub** and find your `ecom` repo
4. For the **web** app:
   - Set environment variables:
     - `NEXT_PUBLIC_API_URL=https://your-api-production.up.railway.app`
     - `SUPABASE_URL=https://your-project.supabase.co`
     - `SUPABASE_ANON_KEY=your_anon_key`
   - Click **Deploy**
5. For the **storefront** app:
   - Repeat the import and set the same variables
   - Click **Deploy**
6. Wait for build to finish. Copy your Vercel URLs (e.g. `https://ecom-web.vercel.app`)

---

### 9. Verify Your Live Website

- Visit your Vercel dashboard and storefront URLs
- Visit your Railway API URL (GraphQL playground)
- Test login, registration, and AI features
- If anything fails, check Vercel/Railway build logs and environment variables

---

### 10. (Optional) Custom Domain Setup

1. In Vercel, go to your project → **Settings** → **Domains**
2. Add your custom domain and follow DNS instructions
3. Repeat for storefront if needed

---

### 11. Ongoing Development & Updates

1. Make code changes locally
2. Commit and push to GitHub
3. Vercel and Railway will auto-deploy your changes

---

### 12. Troubleshooting

- Check [docs/GITHUB_DEPLOYMENT.md](docs/GITHUB_DEPLOYMENT.md) for full deployment guide
- Check [docs/FREE_AI_INTEGRATION.md](docs/FREE_AI_INTEGRATION.md) for AI setup
- Check [docs/SUPABASE_SETUP.md](docs/SUPABASE_SETUP.md) for database setup
- Review Vercel and Railway build logs for errors

---

**Your website is now live and fully powered by free AI and Supabase!**
