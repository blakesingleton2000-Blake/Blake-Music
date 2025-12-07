# What I Need From You - Quick Checklist

## ✅ Already Have

- ✅ Supabase keys (all 3)
- ✅ RunPod endpoint ID (`60f1l3y3ck0sp2`)
- ✅ Handler code updated and optimized
- ✅ Dockerfile ready

---

## 🔴 Critical - Need These to Launch

### 1. **RunPod API Key** ✅ DONE
**What**: The API key for making REST API calls to RunPod  
**Key**: `YOUR_RUNPOD_API_KEY`  
**Action**: 
- Add to `app/.env.local`: `RUNPOD_API_KEY=YOUR_RUNPOD_API_KEY`
- Add to Vercel: Settings → Environment Variables
- See `RUNPOD_KEY_SETUP.md` for details

**Status**: ✅ Key received - need to add to environment variables

---

### 2. **Update RunPod Handler Code** (10-15 minutes)
**What**: Deploy the updated `handler.py` to your RunPod endpoint  
**Options**:

**Option A: GitHub Integration (Easiest)**
1. Push your code to GitHub (if not already)
2. In RunPod Dashboard → Your Endpoint → Edit
3. Connect GitHub repo
4. Select branch (`main`)
5. RunPod rebuilds automatically

**Option B: Docker Build & Push**
```bash
cd runpod
docker build -t musicgen-runpod:latest .
docker tag musicgen-runpod:latest YOUR_DOCKERHUB_USERNAME/musicgen-runpod:latest
docker push YOUR_DOCKERHUB_USERNAME/musicgen-runpod:latest
```
Then update endpoint to use this image.

**Status**: ⏳ Need to deploy handler code

---

### 3. **Apply Supabase Migrations** (15 minutes)
**What**: Create all database tables and functions  
**Files**: 
- `supabase/migrations/20250107000000_initial_schema.sql`
- `supabase/migrations/20250107000001_recommendations_function.sql`
- Or use `combined-migration.sql` (all-in-one)

**Action**:
1. Go to Supabase Dashboard → SQL Editor
2. Copy contents of `combined-migration.sql`
3. Paste and run
4. Verify tables created (check Database → Tables)

**Status**: ⏳ Need to run migrations

---

### 4. **Create Supabase Storage Bucket** (5 minutes)
**What**: Storage bucket for audio files  
**Action**:
1. Go to Supabase Dashboard → Storage
2. Click "New bucket"
3. Name: `audio`
4. Public: ✅ Yes (for signed URLs)
5. Run this SQL in SQL Editor:

```sql
-- Allow public read access
CREATE POLICY "Public audio access" ON storage.objects
FOR SELECT USING (bucket_id = 'audio');

-- Allow authenticated uploads
CREATE POLICY "Authenticated uploads" ON storage.objects
FOR INSERT WITH CHECK (bucket_id = 'audio' AND auth.role() = 'authenticated');
```

**Status**: ⏳ Need to create bucket

---

## 🟡 Important - For Full Features

### 5. **OpenAI API Key** ✅ DONE
**Why**: For "Because you like X..." explanations and screenshot OCR  
**Key**: Received and saved  
**Action**: Add to `.env.local` and Vercel (see `OPENAI_KEY_SETUP.md`)

**Status**: ✅ Key received - need to add to environment variables

---

### 6. **Stripe Keys** (Optional but Recommended)
**Why**: For premium subscriptions and payments  
**Where**: https://dashboard.stripe.com/  
**Need**:
- Secret key (`sk_test_...`)
- Publishable key (`pk_test_...`)
- Webhook secret (after creating webhook)
- Price IDs (create products first)

**Status**: ⏳ Optional for now

---

### 7. **Spotify OAuth** (Optional)
**Why**: Import user playlists  
**Where**: https://developer.spotify.com/dashboard  
**Need**: Client ID + Secret

**Status**: ⏳ Optional for now

---

## 📋 Priority Order

### To Get Basic App Working:
1. ✅ Supabase keys (DONE)
2. ✅ RunPod API key (RECEIVED - add to env vars)
3. ⏳ Update RunPod handler code (YOU NEED TO DO)
4. ⏳ Apply Supabase migrations (YOU NEED TO DO)
5. ⏳ Create storage bucket (YOU NEED TO DO)

**Time**: ~45 minutes total

### To Get Full Features:
6. ✅ OpenAI key (RECEIVED - add to env vars)
7. ⏳ Stripe keys (optional)
8. ⏳ Spotify keys (optional)

---

## 🚀 Quick Start Commands

Once you have the RunPod API key:

```bash
# 1. Add to .env.local
echo "RUNPOD_API_KEY=your_key_here" >> app/.env.local

# 2. Test locally
cd app
npm run dev

# 3. Test RunPod endpoint
curl -X POST https://api.runpod.io/v2/60f1l3y3ck0sp2/run \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"input": {"prompt": "test", "duration_seconds": 30}}'
```

---

## ✅ Summary

**What I can do for you**:
- ✅ Code is ready
- ✅ Handler optimized
- ✅ Dockerfile ready
- ✅ All integrations coded

**What you need to do**:
1. Get RunPod API key (5 min)
2. Deploy handler code to RunPod (10-15 min)
3. Run Supabase migrations (15 min)
4. Create storage bucket (5 min)

**Total time**: ~45 minutes to get basic app working!

---

**TL;DR**: I need you to:
1. Get RunPod API key
2. Deploy handler code
3. Run database migrations
4. Create storage bucket

Everything else is optional! 🎉

