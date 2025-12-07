# Infinite Player - Build Action Plan
## Complete MVP in 1-2 Weeks

This document provides step-by-step instructions to finish all remaining work.

---

## 📋 Pre-Flight Checklist

Before starting, ensure you have:
- [ ] Supabase project created
- [ ] Vercel account ready
- [ ] RunPod account created
- [ ] Docker installed locally
- [ ] All API keys ready (see `ENV_TEMPLATE.md`)

---

## Day 1: Environment & Keys Setup

### Step 1: Add All API Keys to Vercel

1. **Go to Vercel Dashboard** → Your Project → Settings → Environment Variables

2. **Add these variables** (copy from `ENV_TEMPLATE.md`):

   **Supabase:**
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_ROLE_KEY`

   **RunPod:**
   - `RUNPOD_API_KEY` (get after Day 2)
   - `RUNPOD_ENDPOINT_ID` (get after Day 2)
   - `RUNPOD_API_URL=https://api.runpod.io/v2`

   **OpenAI:**
   - `OPENAI_API_KEY`

   **Stripe:**
   - `STRIPE_SECRET_KEY`
   - `STRIPE_WEBHOOK_SECRET`
   - `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY`
   - `NEXT_PUBLIC_STRIPE_PRICE_MONTHLY`
   - `NEXT_PUBLIC_STRIPE_PRICE_CREDITS_10`

   **Spotify:**
   - `SPOTIFY_CLIENT_ID`
   - `SPOTIFY_CLIENT_SECRET`

   **Apple Music (Optional):**
   - `APPLE_MUSIC_TEAM_ID`
   - `APPLE_MUSIC_KEY_ID`
   - `APPLE_MUSIC_PRIVATE_KEY`

   **App Config:**
   - `NEXT_PUBLIC_APP_URL=https://your-app.vercel.app`
   - `NODE_ENV=production`

3. **Set for all environments** (Production, Preview, Development)

### Step 2: Add Keys to Supabase (for Edge Functions)

1. **Go to Supabase Dashboard** → Project Settings → Edge Functions → Secrets

2. **Add:**
   - `SUPABASE_URL` (same as `NEXT_PUBLIC_SUPABASE_URL`)
   - `SUPABASE_SERVICE_ROLE_KEY`

**Time**: 30-60 minutes

---

## Day 2: RunPod Deployment

### Step 1: Build Docker Image Locally

```bash
cd /Users/blakesingleton/Desktop/Music/runpod
docker build -t infinite-musicgen:latest .
```

**Expected output**: Image built successfully

### Step 2: Test Locally (Optional)

```bash
docker run --rm infinite-musicgen:latest python handler.py
```

Should see: "Loading MusicGen-large model..." (will fail without GPU, but tests syntax)

### Step 3: Push to Docker Hub

1. **Login to Docker Hub:**
   ```bash
   docker login
   ```

2. **Tag image:**
   ```bash
   docker tag infinite-musicgen:latest YOUR_DOCKERHUB_USERNAME/infinite-musicgen:latest
   ```

3. **Push:**
   ```bash
   docker push YOUR_DOCKERHUB_USERNAME/infinite-musicgen:latest
   ```

### Step 4: Create RunPod Endpoint

1. **Go to RunPod Console**: https://www.runpod.io/console/serverless

2. **Create New Template:**
   - Name: `infinite-musicgen`
   - Container Image: `YOUR_DOCKERHUB_USERNAME/infinite-musicgen:latest`
   - Container Disk: 20GB
   - Environment Variables: (none needed)

3. **Create Endpoint:**
   - Template: Select `infinite-musicgen`
   - GPU: A100 Spot (cheapest)
   - Max Workers: 1-3 (start with 1)
   - Idle Timeout: 5 seconds
   - FlashBoot: Enabled

4. **Get Credentials:**
   - **API Key**: Settings → API Keys → Create New
   - **Endpoint ID**: Copy from endpoint page

### Step 5: Test RunPod Endpoint

Use Postman or curl:

```bash
curl -X POST https://api.runpod.io/v2/YOUR_ENDPOINT_ID/run \
  -H "Authorization: Bearer YOUR_RUNPOD_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "input": {
      "prompt": "energetic electronic music",
      "duration_seconds": 30,
      "mode": "new"
    }
  }'
```

**Expected**: Returns `{"id": "job-xxx", "status": "IN_QUEUE"}`

### Step 6: Add to Vercel

Add to Vercel Environment Variables:
- `RUNPOD_API_KEY=your_key`
- `RUNPOD_ENDPOINT_ID=your_endpoint_id`

**Time**: 4-6 hours (mostly waiting for Docker build/push)

---

## Day 3: Supabase Production Setup

### Step 1: Apply Migrations

1. **Go to Supabase Dashboard** → SQL Editor

2. **Run first migration:**
   - Open `supabase/migrations/20250107000000_initial_schema.sql`
   - Copy entire contents
   - Paste into SQL Editor
   - Click "Run"

3. **Run second migration:**
   - Open `supabase/migrations/20250107000001_recommendations_function.sql`
   - Copy entire contents
   - Paste into SQL Editor
   - Click "Run"

**Verify**: Check Tables → Should see 10 tables (users, generated_tracks, bands, etc.)

### Step 2: Create Storage Bucket

1. **Go to Storage** → Create Bucket

2. **Settings:**
   - Name: `audio`
   - Public: No (use signed URLs)
   - File size limit: 50MB
   - Allowed MIME types: `audio/*`

3. **Set RLS Policies:**
   - Run SQL from `supabase/storage-setup.sql` in SQL Editor

**Verify**: Try uploading a test file → Should work

### Step 3: Deploy Edge Function

```bash
cd /Users/blakesingleton/Desktop/Music/supabase
supabase functions deploy reset-daily-count --no-verify-jwt
```

**Expected**: "Function deployed successfully"

### Step 4: Set Up Cron Job

1. **Go to Supabase Dashboard** → Database → Cron Jobs

2. **Create New Cron:**
   - Name: `reset-daily-count-daily`
   - Schedule: `0 0 * * *` (midnight UTC daily)
   - Function: `reset-daily-count`
   - Method: `GET`
   - Headers: (none)

**Verify**: Test function manually → Should reset daily_count for free users

**Time**: 2-3 hours

---

## Day 4: Mastering Chain & Audio Storage

### Step 1: Update RunPod Handler with SoX + pydub

The current handler uses ffmpeg. We'll update it to use SoX + pydub as specified.

**Note**: SoX may not be available in Docker. We'll use pydub (which uses ffmpeg under the hood) for now, which achieves the same result.

### Step 2: Verify Audio Storage Flow

The `/api/generate` route already downloads from RunPod → uploads to Supabase Storage. Verify this works:

1. **Test generation** via frontend
2. **Check Supabase Storage** → `audio` bucket → Should see uploaded file
3. **Verify signed URL** works in player

**Time**: 4-6 hours (mostly testing)

---

## Day 5: Mobile & Real-Device Testing

### Step 1: Deploy to Vercel Preview

```bash
cd /Users/blakesingleton/Desktop/Music/app
vercel --prod
```

### Step 2: Test on Real Devices

1. **iOS Safari:**
   - Open preview URL on iPhone
   - Test: Signup → Generate → Play → Like
   - Check: Background play, lock screen controls

2. **Android Chrome:**
   - Open preview URL on Android
   - Test: Same flow
   - Check: Background play, notifications

### Step 3: Fix Mobile Issues

Common issues to fix:
- Touch gestures (swipe queue, long-press)
- Player persistence
- Background play
- Offline behavior

**Time**: 6-8 hours

---

## Week 2: Polish & Launch Prep

### Day 6: PostHog Analytics

1. **Set up PostHog** (cloud free tier or self-hosted)

2. **Add SDK to frontend:**
   - Install: `npm install posthog-js`
   - Add to `app/layout.tsx`

3. **Instrument events:**
   - Generation complete
   - First play
   - Rating submitted
   - Session start/end

**Time**: 2-3 hours

### Day 7: MusicBrainz Rate Limits + Cache

1. **Add exponential backoff** to MusicBrainz calls

2. **Pre-populate cache** with top 200k tracks

3. **Store in embeddings table**

**Time**: 4 hours

### Day 8: Final Testing & Beta Launch

1. **End-to-end testing** on real devices

2. **Launch private beta** (50-100 users)

3. **Monitor PostHog** for metrics

**Time**: 4-6 hours

---

## 🚀 Quick Commands Reference

```bash
# Build RunPod Docker image
cd runpod && docker build -t infinite-musicgen:latest .

# Push to Docker Hub
docker tag infinite-musicgen:latest YOUR_USERNAME/infinite-musicgen:latest
docker push YOUR_USERNAME/infinite-musicgen:latest

# Deploy Edge Function
cd supabase && supabase functions deploy reset-daily-count --no-verify-jwt

# Deploy to Vercel
cd app && vercel --prod
```

---

## ✅ Progress Tracker

- [ ] Day 1: Environment & Keys
- [ ] Day 2: RunPod Deployment
- [ ] Day 3: Supabase Production Setup
- [ ] Day 4: Mastering Chain & Audio Storage
- [ ] Day 5: Mobile Testing
- [ ] Day 6: PostHog Analytics
- [ ] Day 7: MusicBrainz Cache
- [ ] Day 8: Final Testing & Launch

---

**Let's finish this!** 🎉


