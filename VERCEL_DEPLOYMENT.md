# Vercel Deployment Guide

## Quick Deploy to Vercel

### Step 1: Connect Your Repository

1. **Push to GitHub** (if not already):
   ```bash
   cd /Users/blakesingleton/Desktop/Music
   git init
   git add .
   git commit -m "Initial commit: Database schema + Next.js setup"
   # Create repo on GitHub, then:
   git remote add origin https://github.com/yourusername/infinite-player.git
   git push -u origin main
   ```

### Step 2: Deploy to Vercel

**Option A: Via Vercel Dashboard** ⭐ (Easiest)

1. Go to: https://vercel.com/new
2. Click **Import Git Repository**
3. Select your GitHub repo
4. Configure:
   - **Framework Preset**: Next.js (auto-detected)
   - **Root Directory**: `app` (important!)
   - **Build Command**: `npm run build` (auto)
   - **Output Directory**: `.next` (auto)
   - **Install Command**: `npm install` (auto)

5. **Add Environment Variables**:
   ```
   NEXT_PUBLIC_SUPABASE_URL=https://djszkpgtwhdjhexnjdof.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=sb_publishable_cK8kjrpekz2ssEwQOBvbtw_yxM37UGQ
   SUPABASE_SERVICE_ROLE_KEY=sb_secret_Nfa9TqrXPq6v-nKqb19nFg_B3FukR8X
   ```
   (Add other keys as you get them: OpenAI, RunPod, Stripe, etc.)

6. Click **Deploy**

**Option B: Via Vercel CLI**

```bash
# Install Vercel CLI
npm i -g vercel

# Login
vercel login

# Deploy
cd app
vercel

# Follow prompts:
# - Set up and deploy? Yes
# - Which scope? Your account
# - Link to existing project? No
# - Project name? infinite-player
# - Directory? ./
# - Override settings? No
```

### Step 3: Configure Root Directory (Important!)

Since your Next.js app is in the `app/` subdirectory:

1. Go to Vercel Dashboard → Your Project → **Settings**
2. Scroll to **Root Directory**
3. Set to: `app`
4. Save

### Step 4: Add Environment Variables

Go to **Settings** → **Environment Variables** and add:

**Production, Preview, Development:**
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`

**Production Only** (add when ready):
- `OPENAI_API_KEY`
- `RUNPOD_API_KEY`
- `RUNPOD_ENDPOINT_ID`
- `STRIPE_SECRET_KEY`
- `STRIPE_PUBLISHABLE_KEY`
- `STRIPE_MODE=live`

### Step 5: Verify Deployment

1. Visit your Vercel URL (e.g., `https://infinite-player.vercel.app`)
2. Check browser console for errors
3. Test Supabase connection (should see no errors)

---

## Project Structure

```
Music/
├── app/                    # Next.js app (deployed to Vercel)
│   ├── app/                # Next.js App Router
│   ├── lib/                # Utilities (Supabase clients)
│   ├── components/         # React components
│   └── ...
├── supabase/               # Supabase config & migrations
│   ├── migrations/         # Database migrations
│   └── functions/          # Edge Functions
└── ...
```

**Vercel Root Directory**: `app`

---

## Continuous Deployment

Once connected:
- **Every push to `main`** → Auto-deploys to production
- **Every PR** → Creates preview deployment
- **Build logs** → Available in Vercel Dashboard

---

## Troubleshooting

### Build Fails: "Cannot find module"

- Check **Root Directory** is set to `app`
- Verify `package.json` exists in `app/` directory

### Environment Variables Not Working

- Ensure `NEXT_PUBLIC_*` vars are set in Vercel Dashboard
- Redeploy after adding new env vars

### Supabase Connection Errors

- Verify Supabase URL and keys are correct
- Check RLS policies allow public access where needed

---

## Next Steps After Deployment

1. ✅ Database migrations applied
2. ✅ Next.js app deployed to Vercel
3. 🔄 Set up API routes (`/api/generate`, `/api/play`, etc.)
4. 🔄 Build onboarding flow
5. 🔄 Create UI components

