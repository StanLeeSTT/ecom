# GITHUB & DEPLOYMENT GUIDE

Complete guide to upload LEGIMI COMMERCE to GitHub and deploy to free hosting platforms.

---

## 🚀 DEPLOYMENT STRATEGY

### Free Hosting Options:

| Platform | Frontend | Backend | Database | Cost |
|----------|----------|---------|----------|------|
| **Vercel** | ✅ Free | ❌ (use API route) | — | Free |
| **Railway** | ✅ Free | ✅ Free | ✅ Free | Free |
| **Render** | ✅ Free | ✅ Free | ❌ | Free |
| **Netlify** | ✅ Free | ⚠️ Limited | — | Free |
| **Supabase** | — | — | ✅ Free | Free |

**Recommended Stack:**
- **Frontend**: Vercel (Next.js optimized)
- **Backend**: Railway (NestJS optimized)
- **Database**: Supabase (free tier)
- **Repository**: GitHub (free public/private)

---

## PART 1: GITHUB SETUP

### Step 1: Initialize Git Repository

```bash
cd ~/Desktop/ecom

# Initialize git
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: LEGIMI Commerce monorepo setup"
```

### Step 2: Create GitHub Repository

1. Go to https://github.com/new
2. Enter **Repository name**: `legimi-commerce`
3. Choose visibility: **Public** (to showcase your work)
4. Click "Create repository"
5. Copy the repository URL

### Step 3: Push to GitHub

```bash
# Add remote (replace URL with yours)
git remote add origin https://github.com/YOUR_USERNAME/legimi-commerce.git

# Rename branch to main (if needed)
git branch -M main

# Push code
git push -u origin main

# Verify
git remote -v
```

### Step 4: Add `.gitignore` (Already Created)

Verify `.gitignore` includes:
```
node_modules/
.env.local
.env.*.local
dist/
.next/
dist/
```

### Step 5: Protect Main Branch (Optional)

In GitHub → Settings → Branches:
1. Add branch protection rule
2. Require pull requests before merging
3. Require status checks to pass

---

## PART 2: FRONTEND DEPLOYMENT (Vercel)

### Step 1: Deploy Web Dashboard (apps/web)

1. Go to https://vercel.com
2. Click "Import Project"
3. Select "GitHub"
4. Find `legimi-commerce` repository
5. Click "Import"

### Step 2: Configure Environment

In Vercel Dashboard → Settings → Environment Variables:

```env
NEXT_PUBLIC_API_URL=https://your-api.railway.app
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_anon_key
```

### Step 3: Deploy

Click "Deploy" → Wait for build to complete → Your dashboard is live!

**URL**: `https://legimi-web-production.vercel.app`

### Step 4: Deploy Storefront (apps/storefront)

Repeat the same process for `apps/storefront`:

1. Vercel → Import Project
2. Select `legimi-commerce`
3. Choose root directory: `apps/storefront`
4. Add same environment variables
5. Deploy

**URL**: `https://legimi-storefront-production.vercel.app`

### Vercel Configuration File:

Create `vercel.json` in root:

```json
{
  "builds": [
    {
      "src": "apps/web/package.json",
      "use": "@vercel/next"
    },
    {
      "src": "apps/storefront/package.json",
      "use": "@vercel/next"
    }
  ],
  "routes": [
    {
      "src": "/.*",
      "dest": "apps/web"
    }
  ]
}
```

---

## PART 3: BACKEND DEPLOYMENT (Railway)

### Step 1: Create Railway Account

1. Go to https://railway.app
2. Sign up with GitHub
3. Connect GitHub account

### Step 2: Deploy NestJS API

1. Click "New Project" → "Deploy from GitHub"
2. Select `legimi-commerce` repository
3. Click "Add Service" → "Docker"
4. Configure:
   - **Dockerfile location**: `apps/api/Dockerfile`
   - **Build command**: `pnpm build`
   - **Start command**: `pnpm start:prod`

### Step 3: Add Environment Variables

In Railway Dashboard → Variables:

```env
NODE_ENV=production
PORT=3001

# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_KEY=your_service_key

# AI Services
GROQ_API_KEY=your_groq_key
HUGGING_FACE_API_KEY=your_hf_key
REPLICATE_API_KEY=your_replicate_key

# JWT Secrets
JWT_SECRET=generate_secure_random_string
```

### Step 4: Add Database Service

1. In Railway project → "New Service" → "PostgreSQL"
2. Set DATABASE_URL (Railway auto-configures)
3. Railway will provide connection string

### Step 5: Deploy

Railway auto-deploys when you push to GitHub. Monitor in "Deployments" tab.

**URL**: `https://your-api-production.railway.app`

### Create Dockerfile (apps/api/Dockerfile):

```dockerfile
FROM node:20-alpine

WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Copy workspace files
COPY pnpm-workspace.yaml package.json pnpm-lock.yaml ./
COPY packages ./packages
COPY apps/api ./apps/api

# Install dependencies
RUN pnpm install --prod

# Build
RUN cd apps/api && pnpm build

EXPOSE 3001

CMD ["node", "apps/api/dist/main.js"]
```

---

## PART 4: DATABASE SETUP (Supabase)

### Already Completed

See [SUPABASE_SETUP.md](./SUPABASE_SETUP.md) for full setup guide.

Quick summary:
1. ✅ Create Supabase project
2. ✅ Get DATABASE_URL
3. ✅ Add to Railway environment
4. ✅ Run migrations
5. ✅ Setup authentication

---

## PART 5: GITHUB ACTIONS (Optional CI/CD)

### Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup pnpm
        uses: pnpm/action-setup@v2
        with:
          version: 8

      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: 20
          cache: "pnpm"

      - name: Install dependencies
        run: pnpm install

      - name: Type check
        run: pnpm type-check

      - name: Lint
        run: pnpm lint

      - name: Test
        run: pnpm test

      - name: Build
        run: pnpm build

      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v20
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}

      - name: Deploy to Railway
        run: |
          curl -X POST https://railway.app/api/webhooks/deploy \
            -H "Authorization: Bearer ${{ secrets.RAILWAY_TOKEN }}" \
            -H "Content-Type: application/json" \
            -d '{"service":"api"}'
```

---

## PART 6: DOMAIN SETUP

### Connect Custom Domain

#### On Vercel (Frontend):
1. Dashboard → Settings → Domains
2. Add custom domain: `legimi.yourcompany.com`
3. Update DNS records as shown

#### Update in `.env`:

```env
# Update frontend URLs
NEXT_PUBLIC_APP_URL=https://legimi.yourcompany.com
NEXT_PUBLIC_STORE_URL=https://store.legimi.yourcompany.com

# Update backend URL
NEXT_PUBLIC_API_URL=https://api.legimi.yourcompany.com
```

---

## PART 7: MONITORING & LOGGING

### Vercel Analytics

1. Vercel Dashboard → Settings → Analytics
2. View real-time metrics:
   - ✅ Requests
   - ✅ Performance
   - ✅ Status codes

### Railway Logs

1. Railway Dashboard → Services → API → Logs
2. Monitor:
   - ✅ Deploy logs
   - ✅ Runtime logs
   - ✅ Error logs

### Supabase Monitoring

1. Supabase Dashboard → Logs
2. Check:
   - ✅ Database queries
   - ✅ Auth events
   - ✅ API calls

---

## DEPLOYMENT CHECKLIST

### Before Deploying:
- [ ] All code committed to GitHub
- [ ] No `.env.local` in repository
- [ ] All tests passing
- [ ] TypeScript strict mode enabled
- [ ] Environment variables documented

### Frontend (Vercel):
- [ ] Create Vercel account
- [ ] Connect GitHub
- [ ] Import `legimi-commerce` repository
- [ ] Set environment variables
- [ ] Deploy apps/web
- [ ] Deploy apps/storefront
- [ ] Test both deployments

### Backend (Railway):
- [ ] Create Railway account
- [ ] Connect GitHub
- [ ] Add Docker service
- [ ] Set environment variables
- [ ] Deploy API
- [ ] Test API endpoints

### Database (Supabase):
- [ ] Create Supabase project
- [ ] Get connection string
- [ ] Add to Railway env
- [ ] Run migrations
- [ ] Verify tables created

### Integration:
- [ ] Update `NEXT_PUBLIC_API_URL` in Vercel
- [ ] Test API calls from frontend
- [ ] Check database connections
- [ ] Verify file uploads
- [ ] Test authentication

### Monitoring:
- [ ] Setup error tracking (Sentry optional)
- [ ] Enable Vercel analytics
- [ ] Check Railway logs
- [ ] Monitor Supabase usage

---

## PRODUCTION URLs

Once deployed:

```
Frontend (Dashboard): https://legimi-web-production.vercel.app
Storefront: https://legimi-storefront-production.vercel.app
API: https://your-api-production.railway.app
Database: Supabase (managed)
```

---

## CONTINUOUS DEPLOYMENT

### Automatic Deployments:

1. Make changes locally
2. Commit and push to GitHub: `git push`
3. GitHub Actions runs tests (optional)
4. Vercel auto-deploys frontend
5. Railway auto-deploys backend
6. Done! 🚀

### No manual deploys needed!

---

## TROUBLESHOOTING

### Vercel Build Fails:

1. Check build logs: Vercel Dashboard → Deployments
2. Common issues:
   - Missing environment variables
   - Module not found
   - TypeScript errors

### Railway Deploy Fails:

1. Check logs: Railway Dashboard → Services → Logs
2. Common issues:
   - Docker build error
   - Missing dependencies
   - Port conflicts

### Database Connection Error:

1. Verify DATABASE_URL is correct
2. Check Supabase project is running
3. Verify network access policies

### API Not Responding:

1. Check Railway service is running
2. Verify environment variables
3. Check Supabase connection
4. Review API logs

---

## COST ANALYSIS

| Service | Tier | Cost | Notes |
|---------|------|------|-------|
| GitHub | Public | FREE | ✅ No cost |
| Vercel | Hobby | FREE | ✅ Includes SSL, CDN |
| Railway | Free | FREE | ✅ 5GB/month storage |
| Supabase | Free | FREE | ✅ 8GB storage, unlimited users |
| Custom Domain | Optional | $10-15/year | Optional |
| AI Services | Free tier | FREE | ✅ Groq, Hugging Face, etc. |
| **TOTAL** | — | **$0/month** | ✅ Completely free! |

---

## NEXT STEPS

1. ✅ Push code to GitHub
2. ✅ Deploy frontend to Vercel
3. ✅ Deploy backend to Railway
4. ✅ Setup Supabase (see SUPABASE_SETUP.md)
5. ✅ Setup AI services (see FREE_AI_INTEGRATION.md)
6. ✅ Test all systems
7. ✅ Connect custom domain (optional)
8. ✅ Setup monitoring
9. ✅ Go live! 🎉

---

**Total deployment time: ~1 hour**
**Cost: $0 (free tier)**
**Scalability: Ready to scale with payment when needed**

---

See [FREE_AI_INTEGRATION.md](./FREE_AI_INTEGRATION.md) and [SUPABASE_SETUP.md](./SUPABASE_SETUP.md) for complete setup guides.
