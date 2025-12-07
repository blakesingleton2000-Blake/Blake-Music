# Quick Start Deployment Guide

## 🚀 Step-by-Step: Get to Production in 1-2 Days

Follow these steps in order. Each step builds on the previous one.

---

## ✅ Step 1: Environment Variables (30-60 min)

### Vercel Environment Variables

1. Go to: https://vercel.com/dashboard → Your Project → Settings → Environment Variables

2. Add these (one by one, or import from `.env.local`):

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGc...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGc...

# RunPod (get after Step 2)
RUNPOD_API_KEY=your_key_here
RUNPOD_ENDPOINT_ID=your_endpoint_id_here
RUNPOD_API_URL=https://api.runpod.io/v2

# OpenAI
OPENAI_API_KEY=sk-...

# Stripe
STRIPE_SECRET_KEY=sk_test_...
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
NEXT_PUBLIC_STRIPE_PRICE_MONTHLY=price_...
NEXT_PUBLIC_STRIPE_PRICE_CREDITS_10=price_...

# Spotify
SPOTIFY_CLIENT_ID=...
SPOTIFY_CLIENT_SECRET=...

# Apple Music (optional)
APPLE_MUSIC_TEAM_ID=...
APPLE_MUSIC_KEY_ID=...
APPLE_MUSIC_PRIVATE_KEY=...

# App Config
NEXT_PUBLIC_APP_URL=https://your-app.vercel.app
NODE_ENV=production
```

3. **Set for**: Production, Preview, Development (all three)

### Supabase Edge Function Secrets

1. Go to: Supabase Dashboard → Project Settings → Edge Functions → Secrets

2. Add:
   - `SUPABASE_URL` (same as `NEXT_PUBLIC_SUPABASE_URL`)
   - `SUPABASE_SERVICE_ROLE_KEY`

**✅ Checkpoint**: All keys added to Vercel and Supabase

---

## ✅ Step 2: RunPod Deployment (4-6 hours)

### 2.1 Build Docker Image

```bash
cd /Users/blakesingleton/Desktop/Music/runpod
docker build -t infinite-musicgen:latest .
```

**Wait**: This takes 10-20 minutes (downloads PyTorch, MusicGen, etc.)

### 2.2 Push to Docker Hub

```bash
# Login first
docker login

# Tag with your Docker Hub username
docker tag infinite-musicgen:latest YOUR_DOCKERHUB_USERNAME/infinite-musicgen:latest

# Push
docker push YOUR_DOCKERHUB_USERNAME/infinite-musicgen:latest
```

**Wait**: Push takes 5-10 minutes

### 2.3 Create RunPod Template

1. Go to: https://www.runpod.io/console/serverless/templates
2. Click "New Template"
3. Fill in:
   - **Name**: `infinite-musicgen`
   - **Container Image**: `YOUR_DOCKERHUB_USERNAME/infinite-musicgen:latest`
   - **Container Disk**: `20 GB`
   - **Environment Variables**: (leave empty)
4. Click "Create Template"

### 2.4 Create RunPod Endpoint

1. Go to: https://www.runpod.io/console/serverless/endpoints
2. Click "New Endpoint"
3. Fill in:
   - **Template**: Select `infinite-musicgen`
   - **GPU**: `A100 Spot` (cheapest)
   - **Max Workers**: `1` (start small)
   - **Idle Timeout**: `5 seconds`
   - **FlashBoot**: `Enabled`
4. Click "Create Endpoint"
5. **Copy Endpoint ID** (you'll need this)

### 2.5 Get RunPod API Key

1. Go to: https://www.runpod.io/user/settings
2. Click "API Keys" tab
3. Click "Create API Key"
4. **Copy API Key** (you'll need this)

### 2.6 Add to Vercel

Go back to Vercel → Environment Variables → Add:
- `RUNPOD_API_KEY=your_key`
- `RUNPOD_ENDPOINT_ID=your_endpoint_id`

### 2.7 Test RunPod Endpoint

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

**Expected**: `{"id": "job-xxx", "status": "IN_QUEUE"}`

**✅ Checkpoint**: RunPod endpoint working, keys added to Vercel

---

## ✅ Step 3: Supabase Production Setup (2-3 hours)

### 3.1 Apply Migrations

1. Go to: Supabase Dashboard → SQL Editor

2. **Run Migration 1**:
   - Open `supabase/migrations/20250107000000_initial_schema.sql`
   - Copy entire file
   - Paste into SQL Editor
   - Click "Run"
   - **Verify**: Should see "Success" message

3. **Run Migration 2**:
   - Open `supabase/migrations/20250107000001_recommendations_function.sql`
   - Copy entire file
   - Paste into SQL Editor
   - Click "Run"
   - **Verify**: Should see "Success" message

4. **Verify Tables**:
   - Go to: Table Editor
   - Should see: `users`, `generated_tracks`, `bands`, `user_history`, etc. (10 tables)

### 3.2 Create Storage Bucket

1. Go to: Supabase Dashboard → Storage

2. Click "New Bucket"

3. Fill in:
   - **Name**: `audio`
   - **Public**: `No` (we'll use signed URLs)
   - **File size limit**: `50 MB`
   - **Allowed MIME types**: `audio/*`

4. Click "Create Bucket"

5. **Set RLS Policies**:
   - Go to: SQL Editor
   - Run SQL from `supabase/storage-setup.sql`
   - **Verify**: Try uploading a test file → Should work

### 3.3 Deploy Edge Function

```bash
cd /Users/blakesingleton/Desktop/Music/supabase
supabase functions deploy reset-daily-count --no-verify-jwt
```

**Expected**: "Function deployed successfully"

### 3.4 Set Up Cron Job

1. Go to: Supabase Dashboard → Database → Cron Jobs

2. Click "New Cron Job"

3. Fill in:
   - **Name**: `reset-daily-count-daily`
   - **Schedule**: `0 0 * * *` (midnight UTC daily)
   - **Function**: `reset-daily-count`
   - **Method**: `GET`
   - **Headers**: (leave empty)

4. Click "Create"

5. **Test Function**:
   - Go to: Edge Functions → `reset-daily-count` → Invoke
   - Should see: `{"success": true, "reset_count": X}`

**✅ Checkpoint**: Migrations applied, storage bucket created, Edge Function deployed

---

## ✅ Step 4: Deploy to Vercel

```bash
cd /Users/blakesingleton/Desktop/Music/app
vercel --prod
```

**Wait**: Deployment takes 2-5 minutes

**✅ Checkpoint**: App deployed to production!

---

## ✅ Step 5: Test Everything

### Test Flow:

1. **Sign Up**: Create account
2. **Onboarding**: Complete 3 steps
3. **Generate**: Create a new song
4. **Play**: Should play audio
5. **Like**: Like the track
6. **Check**: Daily count should increment

### Verify:

- ✅ Music generation works
- ✅ Audio playback works
- ✅ Storage upload works
- ✅ Daily counter increments
- ✅ Recommendations appear

---

## 🎉 You're Done!

Your app is now live! Monitor:
- Vercel logs for errors
- Supabase logs for database issues
- RunPod console for generation jobs

---

## 🐛 Troubleshooting

### RunPod not working?
- Check API key is correct
- Check endpoint ID is correct
- Check endpoint is active (not paused)

### Storage upload failing?
- Check bucket exists: `audio`
- Check RLS policies are set
- Check service role key is correct

### Migrations failing?
- Check you're running in correct order
- Check for existing tables (may need to drop first)
- Check SQL syntax

---

## 📋 Next Steps (Week 2)

1. Add PostHog analytics
2. Add MusicBrainz cache
3. Test on mobile devices
4. Launch beta!

---

**Need help?** Check `BUILD_ACTION_PLAN.md` for detailed instructions.


