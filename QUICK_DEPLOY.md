# 🚀 Quick Deploy Guide - Phase 1 Critical Items

## ✅ Already Done

- [x] #4: Supabase migrations applied

---

## 🔄 Deploy These Now (30 minutes total)

### 1. Deploy RunPod Template (20 min)

**Files Ready**: `runpod/Dockerfile`, `runpod/handler.py`

**Steps**:
```bash
cd runpod

# Build Docker image
docker build -t musicgen-runpod:latest .

# Tag for your registry (Docker Hub example)
docker tag musicgen-runpod:latest your-username/musicgen-runpod:latest

# Push to registry
docker push your-username/musicgen-runpod:latest
```

**Then**:
1. Go to https://www.runpod.io/
2. Serverless → Templates → Create Template
3. Container Image: `your-username/musicgen-runpod:latest`
4. GPU: A100 Spot
5. Create Template

**Create Endpoint**:
1. Serverless → Endpoints → Create Endpoint
2. Select your template
3. Get Endpoint ID and API Key
4. Add to `app/.env.local`:
   ```env
   RUNPOD_API_KEY=your_key
   RUNPOD_ENDPOINT_ID=your_endpoint_id
   ```

---

### 2. Deploy Edge Function (5 min)

```bash
cd supabase
supabase functions deploy reset-daily-count
```

**Set Up Cron**:
1. Supabase Dashboard → Database → Cron Jobs
2. Create cron:
   - Schedule: `0 0 * * *` (midnight UTC)
   - SQL:
   ```sql
   SELECT net.http_post(
     url := 'https://djszkpgtwhdjhexnjdof.supabase.co/functions/v1/reset-daily-count',
     headers := '{"Authorization": "Bearer YOUR_SERVICE_ROLE_KEY"}'::jsonb
   );
   ```

---

### 3. Verify Storage Bucket (2 min)

1. Supabase Dashboard → Storage
2. Check if `audio` bucket exists
3. If not, run storage-setup.sql again

---

## ⏭️ Can Do Later

- **#6: Mastering Chain** - Code updated in handler.py (uses ffmpeg)
- **#8: Voice Presets** - Optional for MVP
- **#9: PostHog** - Can add after launch

---

**Start with RunPod deployment - that's the biggest blocker!** 🎯

