# 🚀 Deploy to Vercel - Complete Guide

## Quick Deploy (2 Methods)

### Method 1: Via Vercel Dashboard (Easiest - 5 minutes)

1. **Push to GitHub** (if not already):
   ```bash
   git add .
   git commit -m "Ready for Vercel deployment"
   git push origin main
   ```

2. **Go to Vercel**:
   - Visit: https://vercel.com/new
   - Click **Import Git Repository**
   - Select your GitHub repo

3. **Configure Project**:
   - **Framework Preset**: Next.js (auto-detected)
   - **Root Directory**: `app` ⚠️ **IMPORTANT**
   - **Build Command**: `npm run build` (default)
   - **Output Directory**: `.next` (default)

4. **Add Environment Variables**:
   Click **Environment Variables** and add:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_ROLE_KEY`
   - `RUNPOD_API_KEY` (after deploying RunPod)
   - `RUNPOD_ENDPOINT_ID` (after deploying RunPod)
   - `OPENAI_API_KEY` (optional for now)
   - `STRIPE_SECRET_KEY` (optional for now)
   - Others as needed

5. **Deploy**:
   - Click **Deploy**
   - Wait ~2-3 minutes
   - Get your live URL!

---

### Method 2: Via Vercel CLI (5 minutes)

1. **Install Vercel CLI** (if not installed):
   ```bash
   npm install -g vercel
   ```

2. **Login**:
   ```bash
   vercel login
   ```

3. **Deploy**:
   ```bash
   cd app
   vercel
   ```

4. **Follow prompts**:
   - Link to existing project? No (first time)
   - Project name: infinite-player (or your choice)
   - Directory: `./` (current directory)
   - Override settings? No

5. **Add environment variables**:
   ```bash
   vercel env add NEXT_PUBLIC_SUPABASE_URL
   vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY
   vercel env add SUPABASE_SERVICE_ROLE_KEY
   # ... add others
   ```

6. **Deploy to production**:
   ```bash
   vercel --prod
   ```

---

## ⚠️ Important: Root Directory

**CRITICAL**: Set root directory to `app` in Vercel settings!

The project structure is:
```
Music/
├── app/          ← This is the Next.js app (deploy this)
├── supabase/     ← Database migrations (not deployed)
└── runpod/       ← Docker files (not deployed)
```

**In Vercel Dashboard**:
- Settings → General → Root Directory: `app`

---

## Environment Variables Needed

Add these in Vercel Dashboard → Settings → Environment Variables:

### Required:
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`

### For Music Generation (after RunPod):
- `RUNPOD_API_KEY`
- `RUNPOD_ENDPOINT_ID`

### Optional (can add later):
- `OPENAI_API_KEY` (for explanations)
- `STRIPE_SECRET_KEY` (for payments)
- OAuth keys (Spotify, Apple Music)

---

## After Deployment

1. **Get your URL**: `https://your-project.vercel.app`
2. **Test the app**: Sign up, navigate, test features
3. **Add custom domain** (optional): Settings → Domains

---

## 🎯 Quick Deploy Command

```bash
cd app
vercel --prod
```

That's it! 🚀

---

**Note**: RunPod is separate (GPU service). Deploy that separately when ready for music generation.

