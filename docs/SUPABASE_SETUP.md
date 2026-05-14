# SUPABASE INTEGRATION GUIDE

Replace local PostgreSQL with **free Supabase** for production-ready database, authentication, and real-time features.

---

## 🚀 Why Supabase?

| Feature | Local DB | Supabase |
|---------|----------|----------|
| **Cost** | Free (local only) | Free tier available |
| **Storage** | Limited | 8GB free |
| **Backups** | Manual | Automatic |
| **Hosting** | Self-hosted | Managed cloud |
| **Auth** | Custom | Built-in, free |
| **Realtime** | Redis cache | Built-in |
| **Uptime** | Your machine | 99.99% SLA |

---

## STEP 1: CREATE SUPABASE PROJECT (2 minutes)

1. Go to https://app.supabase.com
2. Click "New Project"
3. Choose region (closest to your users)
4. Set password (save securely!)
5. Wait for project creation (~5 minutes)
6. Copy your credentials:
   - **Project URL** → `SUPABASE_URL`
   - **Anon Key** → `SUPABASE_ANON_KEY`
   - **Service Role Key** → `SUPABASE_SERVICE_KEY`

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

---

## STEP 2: UPDATE CONFIGURATION

### Update `.env.local`:

```env
# Remove local database URLs, add Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_KEY=your_service_key

# Prisma will now connect to Supabase PostgreSQL
DATABASE_URL=postgresql://postgres:PASSWORD@your-project.supabase.co:5432/postgres
```

### Update `prisma/.env`:

```env
# Get DATABASE_URL from Supabase Dashboard
# Settings → Database → Connection string → URI
DATABASE_URL=postgresql://postgres:PASSWORD@your-project.supabase.co:5432/postgres
```

---

## STEP 3: INSTALL SUPABASE CLIENT

```bash
pnpm add @supabase/supabase-js @supabase/auth-helpers-nextjs @supabase/auth-helpers-react
```

---

## STEP 4: CREATE SUPABASE SERVICE

### Backend Service (NestJS):

```typescript
// apps/api/src/supabase/supabase.service.ts
import { Injectable } from "@nestjs/common";
import { createClient, SupabaseClient } from "@supabase/supabase-js";

@Injectable()
export class SupabaseService {
  private supabase: SupabaseClient;

  constructor() {
    this.supabase = createClient(
      process.env.SUPABASE_URL,
      process.env.SUPABASE_SERVICE_KEY // Use service role for server
    );
  }

  getClient() {
    return this.supabase;
  }

  // User management
  async getUserById(id: string) {
    const { data, error } = await this.supabase
      .from("profiles")
      .select("*")
      .eq("id", id)
      .single();

    if (error) throw error;
    return data;
  }

  async updateUser(id: string, updates: any) {
    const { data, error } = await this.supabase
      .from("profiles")
      .update(updates)
      .eq("id", id);

    if (error) throw error;
    return data;
  }

  // Store management
  async createStore(storeData: any) {
    const { data, error } = await this.supabase
      .from("stores")
      .insert([storeData]);

    if (error) throw error;
    return data[0];
  }

  async getStores(userId: string) {
    const { data, error } = await this.supabase
      .from("stores")
      .select("*")
      .eq("user_id", userId);

    if (error) throw error;
    return data;
  }

  // Real-time subscriptions
  onStoreUpdated(storeId: string, callback: (payload: any) => void) {
    return this.supabase
      .on(
        "postgres_changes",
        {
          event: "*",
          schema: "public",
          table: "stores",
          filter: `id=eq.${storeId}`,
        },
        callback
      )
      .subscribe();
  }

  // File storage
  async uploadFile(bucket: string, path: string, file: File) {
    const { data, error } = await this.supabase.storage
      .from(bucket)
      .upload(path, file);

    if (error) throw error;
    return data;
  }

  async getFileUrl(bucket: string, path: string) {
    const { data } = this.supabase.storage.from(bucket).getPublicUrl(path);
    return data.publicUrl;
  }
}
```

### Frontend Service (Next.js):

```typescript
// apps/web/src/lib/supabase.ts
import { createClientComponentClient } from "@supabase/auth-helpers-nextjs";

export const supabase = createClientComponentClient();

export async function getUserProfile() {
  const { data } = await supabase.auth.getSession();
  if (!data.session) return null;

  const { data: profile } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", data.session.user.id)
    .single();

  return profile;
}

export async function subscribeToStore(storeId: string) {
  return supabase
    .on(
      "postgres_changes",
      {
        event: "*",
        schema: "public",
        table: "stores",
        filter: `id=eq.${storeId}`,
      },
      (payload) => {
        // Handle real-time updates
        console.log("Store updated:", payload);
      }
    )
    .subscribe();
}
```

---

## STEP 5: MIGRATE DATABASE SCHEMA

### Run Prisma migrations:

```bash
cd packages/database

# Push schema to Supabase
pnpm prisma db push

# Or run migrations
pnpm prisma migrate deploy
```

---

## STEP 6: SETUP AUTHENTICATION

### Enable Auth Providers in Supabase Dashboard:

1. Go to Authentication → Providers
2. Enable:
   - ✅ Email (default)
   - ✅ Google
   - ✅ GitHub
   - ✅ Apple

### Create Auth Module:

```typescript
// apps/api/src/auth/auth.service.ts
import { Injectable } from "@nestjs/common";
import { SupabaseService } from "../supabase/supabase.service";

@Injectable()
export class AuthService {
  constructor(private supabase: SupabaseService) {}

  async signUp(email: string, password: string) {
    const { data, error } = await this.supabase.getClient().auth.signUp({
      email,
      password,
    });

    if (error) throw error;

    // Create profile
    await this.supabase.getClient().from("profiles").insert([
      {
        id: data.user.id,
        email: data.user.email,
      },
    ]);

    return data;
  }

  async signIn(email: string, password: string) {
    const { data, error } = await this.supabase
      .getClient()
      .auth.signInWithPassword({
        email,
        password,
      });

    if (error) throw error;
    return data;
  }

  async signOut() {
    const { error } = await this.supabase.getClient().auth.signOut();
    if (error) throw error;
  }

  async resetPassword(email: string) {
    const { error } = await this.supabase
      .getClient()
      .auth.resetPasswordForEmail(email, {
        redirectTo: `${process.env.NEXT_PUBLIC_APP_URL}/reset-password`,
      });

    if (error) throw error;
  }
}
```

### Frontend Auth Component:

```typescript
// apps/web/src/components/auth/SignUp.tsx
"use client";

import { supabase } from "@/lib/supabase";
import { useState } from "react";

export function SignUp() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);

  async function handleSignUp() {
    setLoading(true);
    const { error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        emailRedirectTo: `${window.location.origin}/auth/callback`,
      },
    });

    if (error) {
      console.error(error);
    } else {
      alert("Check your email for verification link");
    }
    setLoading(false);
  }

  return (
    <form onSubmit={(e) => { e.preventDefault(); handleSignUp(); }}>
      <input
        type="email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        placeholder="Email"
      />
      <input
        type="password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        placeholder="Password"
      />
      <button disabled={loading}>
        {loading ? "Loading..." : "Sign Up"}
      </button>
    </form>
  );
}
```

---

## STEP 7: SETUP STORAGE BUCKETS

Create storage buckets for different file types:

### Via SQL in Supabase Dashboard:

```sql
-- Create product images bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('products', 'products', true);

-- Create store assets bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('stores', 'stores', true);

-- Create user profiles bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('profiles', 'profiles', true);
```

### Storage Policies:

```sql
-- Allow users to upload to their own folder
CREATE POLICY "Users can upload" ON storage.objects
  FOR INSERT WITH CHECK (
    auth.uid() = owner
  );

-- Allow public read
CREATE POLICY "Public read" ON storage.objects
  FOR SELECT USING (true);
```

---

## STEP 8: SETUP DATABASE TABLES

### Create Tables via SQL Editor:

```sql
-- Profiles table
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
  email TEXT UNIQUE,
  name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Stores table
CREATE TABLE public.stores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  slug TEXT UNIQUE,
  logo_url TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Products table
CREATE TABLE public.products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES public.stores ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10, 2),
  image_url TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Enable Row Level Security (RLS)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

-- RLS Policies for profiles
CREATE POLICY "Users can read own profile" ON public.profiles
  FOR SELECT USING (auth.uid() = id);

-- RLS Policies for stores
CREATE POLICY "Users can read own stores" ON public.stores
  FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can insert own stores" ON public.stores
  FOR INSERT WITH CHECK (user_id = auth.uid());

-- RLS Policies for products
CREATE POLICY "Users can read products from their stores" ON public.products
  FOR SELECT USING (
    store_id IN (
      SELECT id FROM public.stores WHERE user_id = auth.uid()
    )
  );
```

---

## STEP 9: SETUP REALTIME (Optional)

Enable realtime subscriptions for live updates:

1. Go to Realtime → Publications
2. Enable tables:
   - ✅ profiles
   - ✅ stores
   - ✅ products

---

## STEP 10: TESTING

### Test Connection:

```typescript
// apps/api/src/test.ts
import { createClient } from "@supabase/supabase-js";

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
);

async function test() {
  // Test connection
  const { data, error } = await supabase.from("profiles").select("count()", {
    count: "exact",
  });

  if (error) {
    console.error("Connection failed:", error);
  } else {
    console.log("✅ Connected to Supabase!");
  }
}

test();
```

Run:
```bash
ts-node apps/api/src/test.ts
```

---

## FREE TIER LIMITS

| Feature | Limit | Notes |
|---------|-------|-------|
| Storage | 8 GB | Sufficient for most MVPs |
| Bandwidth | 2 GB/month | Reset monthly |
| Database Size | Unlimited | But 8GB storage cap |
| Real-time messages | 50,000/month | Per project |
| Auth users | Unlimited | No user limit |
| API Requests | Unlimited | No request limit |

---

## MONITORING & OPTIMIZATION

### Enable Query Analytics:

In Supabase Dashboard → SQL Editor → Performance

Check for:
- ✅ Slow queries
- ✅ Missing indexes
- ✅ Unused indexes

### Common Optimizations:

```sql
-- Add indexes for common queries
CREATE INDEX ON stores(user_id);
CREATE INDEX ON products(store_id);
CREATE INDEX ON stores(slug);

-- Analyze query performance
EXPLAIN ANALYZE
SELECT * FROM products WHERE store_id = '...';
```

---

## DEPLOYMENT CHECKLIST

- [ ] Create Supabase project
- [ ] Save credentials to `.env.local`
- [ ] Install Supabase client packages
- [ ] Run database migrations
- [ ] Setup authentication providers
- [ ] Create storage buckets
- [ ] Configure RLS policies
- [ ] Test connection
- [ ] Verify data sync
- [ ] Setup monitoring

---

## NEXT STEPS

1. ✅ Create Supabase project
2. ✅ Add credentials to `.env`
3. ✅ Run migrations
4. ✅ Test connection
5. ✅ Deploy to hosting (see [GITHUB_DEPLOYMENT.md](./GITHUB_DEPLOYMENT.md))

---

**Total setup time: ~15 minutes**
**Cost: $0 (free tier)**
**Scalability: Unlimited with pay-as-you-go**

See [FREE_AI_INTEGRATION.md](./FREE_AI_INTEGRATION.md) for AI setup and [GITHUB_DEPLOYMENT.md](./GITHUB_DEPLOYMENT.md) for deployment.
