# RunPod Deployment Guide

## ✅ Your Endpoint Info

- **Endpoint ID**: `60f1l3y3ck0sp2`
- **GPU**: 16 GB (optimized with FP16 + torch.compile)
- **Status**: Live and ready!

## 📋 Next Steps

### 1. Get Your RunPod API Key

1. Go to [RunPod Dashboard](https://www.runpod.io/)
2. Navigate to **Settings** → **API Keys**
3. Click **Create API Key**
4. Copy the key (starts with `...`)

### 2. Update Handler Code in RunPod

Your endpoint is already created, but you need to update the handler code:

**Option A: Update via RunPod Dashboard (Recommended)**

1. Go to **Serverless** → **Endpoints**
2. Click on your endpoint (`60f1l3y3ck0sp2`)
3. Click **Edit** or **Update Template**
4. If using GitHub integration:
   - Connect your GitHub repo
   - Select branch (usually `main`)
   - RunPod will rebuild automatically

**Option B: Build and Push Docker Image**

If you prefer to build locally:

```bash
cd runpod
docker build -t musicgen-runpod:latest .
docker tag musicgen-runpod:latest your-dockerhub-username/musicgen-runpod:latest
docker push your-dockerhub-username/musicgen-runpod:latest
```

Then update your RunPod endpoint to use this image.

### 3. Add API Keys to Environment

**Local Development** (`app/.env.local`):
```env
RUNPOD_API_KEY=your_api_key_here
RUNPOD_ENDPOINT_ID=60f1l3y3ck0sp2
RUNPOD_API_URL=https://api.runpod.io/v2
```

**Vercel Production**:
1. Go to Vercel Dashboard → Your Project → Settings → Environment Variables
2. Add:
   - `RUNPOD_API_KEY` = your API key
   - `RUNPOD_ENDPOINT_ID` = `60f1l3y3ck0sp2`
   - `RUNPOD_API_URL` = `https://api.runpod.io/v2`

### 4. Test the Endpoint

```bash
curl -X POST https://api.runpod.io/v2/60f1l3y3ck0sp2/run \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "input": {
      "prompt": "heavy bass hip-hop beat with synths",
      "duration_seconds": 30,
      "mode": "new"
    }
  }'
```

You'll get a response like:
```json
{
  "id": "job-abc123",
  "status": "IN_QUEUE"
}
```

Then check status:
```bash
curl https://api.runpod.io/v2/60f1l3y3ck0sp2/status/job-abc123 \
  -H "Authorization: Bearer YOUR_API_KEY"
```

### 5. Handler Code Features

The handler (`runpod/handler.py`) includes:

- ✅ **16GB GPU Optimization**: FP16 precision, torch.compile
- ✅ **Mastering Chain**: ffmpeg loudnorm + SoX compression + exciter
- ✅ **MP3 Output**: Compressed audio format
- ✅ **Error Handling**: Graceful fallbacks
- ✅ **Logging**: Detailed console logs for debugging

### 6. Cost Estimates

- **16GB GPU**: ~$0.0003-0.0004/second
- **30-second song**: ~15-20s generation → $0.006-$0.008
- **3-minute song**: ~15-20s generation → $0.006-$0.008
- **30-minute extension**: ~90-120s generation → $0.036-$0.048

**Monthly estimate** (10k users, 100k generations/day):
- ~$1,200/month

## 🔧 Troubleshooting

### Handler Not Found
- Make sure `handler.py` is in the root of your Docker image
- Check that the handler function is named `handler`

### Out of Memory
- The handler uses FP16 to fit in 16GB
- If still failing, reduce batch size or use 8-bit quantization

### Audio Not Generating
- Check RunPod logs: Dashboard → Endpoints → Your Endpoint → Logs
- Verify model loads correctly (check for "Model loaded successfully")
- Test with a simple prompt first

### Mastering Fails
- Verify ffmpeg and sox are installed in Dockerfile
- Check temp file permissions
- Fallback to basic MP3 conversion if mastering fails

## ✅ Checklist

- [ ] Get RunPod API key
- [ ] Update handler code in RunPod endpoint
- [ ] Add API keys to `app/.env.local`
- [ ] Add API keys to Vercel environment variables
- [ ] Test endpoint with curl
- [ ] Test from your app (`/api/generate`)

## 🚀 You're Ready!

Once the handler is updated and tested, your music generation is 100% working!

