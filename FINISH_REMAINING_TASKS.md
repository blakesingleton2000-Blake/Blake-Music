# 🚀 Finish Remaining Tasks - Action Plan

## ✅ Already Complete

- ✅ All API keys added to Vercel
- ✅ Audio storage flow updated (RunPod → Download → Upload to Supabase)
- ✅ Stripe keys added
- ✅ Code fixes (Suspense, TypeScript errors)
- ✅ Environment variables configured

---

## 🔴 Critical Remaining Tasks

### 1. **Create Supabase Storage Bucket** (5 minutes)

**Action**: Run this SQL in Supabase SQL Editor:

```sql
-- Create audio bucket if it doesn't exist
INSERT INTO storage.buckets (id, name, public)
VALUES ('audio', 'audio', true)
ON CONFLICT (id) DO NOTHING;

-- Allow public read access (for signed URLs)
CREATE POLICY IF NOT EXISTS "Public audio access" ON storage.objects
FOR SELECT USING (bucket_id = 'audio');

-- Allow authenticated uploads
CREATE POLICY IF NOT EXISTS "Authenticated uploads" ON storage.objects
FOR INSERT WITH CHECK (bucket_id = 'audio' AND auth.role() = 'authenticated');

-- Allow users to update their own files
CREATE POLICY IF NOT EXISTS "Users can update own files" ON storage.objects
FOR UPDATE USING (bucket_id = 'audio' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Allow users to delete their own files
CREATE POLICY IF NOT EXISTS "Users can delete own files" ON storage.objects
FOR DELETE USING (bucket_id = 'audio' AND auth.uid()::text = (storage.foldername(name))[1]);
```

**Verify**: Go to Supabase Dashboard → Storage → Should see `audio` bucket

---

### 2. **Deploy Daily Counter Reset Edge Function** (15 minutes)

**Action**: Run these commands:

```bash
cd /Users/blakesingleton/Desktop/Music

# Login to Supabase (if not already)
supabase login

# Link to your project
supabase link --project-ref djszkpgtwhdjhexnjdof

# Deploy the function
cd supabase
supabase functions deploy reset-daily-count --no-verify-jwt
```

**Then set up cron job**:
1. Go to Supabase Dashboard → Database → Cron Jobs
2. Click "New Cron Job"
3. Schedule: `0 0 * * *` (midnight UTC daily)
4. SQL:
```sql
SELECT net.http_post(
  url := 'https://djszkpgtwhdjhexnjdof.supabase.co/functions/v1/reset-daily-count',
  headers := '{"Authorization": "Bearer YOUR_SERVICE_ROLE_KEY"}'::jsonb
);
```

---

### 3. **Deploy RunPod Handler Code** (10-15 minutes)

**Option A: GitHub Integration (Easiest)**
1. Push code to GitHub (if not already)
2. Go to RunPod Dashboard → Your Endpoint (`60f1l3y3ck0sp2`)
3. Click "Edit" or "Update"
4. Connect GitHub repo
5. Select branch (`main`)
6. RunPod rebuilds automatically

**Option B: Docker Build & Push**
```bash
cd runpod
docker build -t musicgen-runpod:latest .
docker tag musicgen-runpod:latest YOUR_DOCKERHUB_USERNAME/musicgen-runpod:latest
docker push YOUR_DOCKERHUB_USERNAME/musicgen-runpod:latest
```
Then update RunPod endpoint to use this image.

---

## 🟡 Important - Next Steps

### 4. **Test End-to-End** (30 minutes)

Once everything is deployed:

1. **Test Music Generation**:
   - Go to `/generate`
   - Generate a track (30 seconds)
   - Verify it completes and plays

2. **Test Storage**:
   - Check Supabase Storage → `audio` bucket
   - Verify file was uploaded
   - Verify signed URL works

3. **Test RunPod**:
   - Check RunPod logs for generation
   - Verify mastering chain ran
   - Verify MP3 output

---

## 📋 Quick Checklist

- [ ] Create Supabase Storage bucket (`audio`)
- [ ] Deploy Edge Function (`reset-daily-count`)
- [ ] Set up cron job for daily reset
- [ ] Deploy RunPod handler code
- [ ] Test music generation end-to-end
- [ ] Verify audio uploads to Supabase Storage
- [ ] Test playback

---

## ✅ Summary

**What's Left**: 3 critical infrastructure tasks (~30 minutes total)

1. Storage bucket (5 min)
2. Edge Function + cron (15 min)
3. RunPod handler deploy (10-15 min)

**Then**: Test everything and you're ready to launch! 🚀

