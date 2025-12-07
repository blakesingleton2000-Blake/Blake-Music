# 🚀 Deploy Everything - Complete Guide

## Quick Deploy (Run These Scripts)

### Step 1: Deploy RunPod Template

**Prerequisites**:
- Docker Desktop running
- Docker Hub account (or GitHub Container Registry)

**Run**:
```bash
./deploy-runpod.sh
```

**Then follow the prompts** to:
1. Tag image
2. Push to registry
3. Create RunPod endpoint
4. Get API keys

---

### Step 2: Deploy Edge Function

**Prerequisites**:
- Supabase CLI logged in (`supabase login`)

**Run**:
```bash
./deploy-edge-function.sh
```

**Then** set up cron job in Supabase Dashboard.

---

## Manual Deployment (If Scripts Don't Work)

### RunPod Manual Steps:

1. **Start Docker Desktop**

2. **Build image**:
   ```bash
   cd runpod
   docker build -t musicgen-runpod:latest .
   ```

3. **Tag for registry**:
   ```bash
   docker tag musicgen-runpod:latest YOUR_USERNAME/musicgen-runpod:latest
   ```

4. **Push**:
   ```bash
   docker login
   docker push YOUR_USERNAME/musicgen-runpod:latest
   ```

5. **Create RunPod endpoint**:
   - https://www.runpod.io/
   - Serverless → Templates → Create
   - Container: `YOUR_USERNAME/musicgen-runpod:latest`
   - GPU: A100 Spot
   - Create Template → Create Endpoint
   - Copy Endpoint ID and API Key

6. **Add to `.env.local`**:
   ```env
   RUNPOD_API_KEY=your_key_here
   RUNPOD_ENDPOINT_ID=your_endpoint_id_here
   ```

---

### Edge Function Manual Steps:

1. **Login to Supabase**:
   ```bash
   supabase login
   ```

2. **Deploy**:
   ```bash
   cd supabase
   supabase functions deploy reset-daily-count
   ```

3. **Set up cron** (in Supabase Dashboard):
   - Database → Cron Jobs
   - Schedule: `0 0 * * *`
   - SQL: See `DEPLOY_EDGE_FUNCTION.md`

---

## Verify Everything

After deploying:

1. **Test RunPod**:
   ```bash
   curl -X POST https://api.runpod.io/v2/YOUR_ENDPOINT_ID/run \
     -H "Authorization: Bearer YOUR_API_KEY" \
     -H "Content-Type: application/json" \
     -d '{"input": {"prompt": "test", "duration_seconds": 30}}'
   ```

2. **Test Edge Function**:
   ```bash
   curl -X POST https://djszkpgtwhdjhexnjdof.supabase.co/functions/v1/reset-daily-count \
     -H "Authorization: Bearer YOUR_SERVICE_ROLE_KEY"
   ```

3. **Verify Storage**:
   - Supabase Dashboard → Storage
   - Should see `audio` bucket

---

## ✅ After Deployment

- ✅ RunPod endpoint ready
- ✅ Edge Function deployed
- ✅ Storage bucket verified
- ⏭️ Add API keys to `.env.local`
- ⏭️ Test app: `cd app && npm run dev`

---

**Start with: `./deploy-runpod.sh`** 🚀

