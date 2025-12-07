# RunPod Serverless Template

This directory contains the RunPod serverless template for MusicGen-large generation.

## Files

- `Dockerfile` - Docker image definition
- `handler.py` - Main handler script
- `README.md` - This file

## Setup Instructions

### 1. Build Docker Image

```bash
cd runpod
docker build -t musicgen-runpod:latest .
```

### 2. Test Locally (Optional)

```bash
docker run --gpus all -it musicgen-runpod:latest python handler.py
```

### 3. Push to Container Registry

**Option A: Docker Hub**

```bash
docker tag musicgen-runpod:latest your-dockerhub-username/musicgen-runpod:latest
docker push your-dockerhub-username/musicgen-runpod:latest
```

**Option B: GitHub Container Registry**

```bash
docker tag musicgen-runpod:latest ghcr.io/your-username/musicgen-runpod:latest
docker push ghcr.io/your-username/musicgen-runpod:latest
```

### 4. Create RunPod Serverless Endpoint

1. Go to [RunPod Dashboard](https://www.runpod.io/)
2. Navigate to **Serverless** → **Templates**
3. Click **Create Template**
4. Fill in:
   - **Name**: `musicgen-large`
   - **Container Image**: `your-registry/musicgen-runpod:latest`
   - **GPU**: A100 (or A40 for cheaper)
   - **Container Disk**: 20GB
   - **Environment Variables**: (none needed)
5. Click **Create**

### 5. Create Endpoint

1. Go to **Serverless** → **Endpoints**
2. Click **Create Endpoint**
3. Select your template
4. Configure:
   - **Name**: `musicgen-production`
   - **GPU Type**: A100 Spot (cheaper) or On-Demand
   - **Max Workers**: 5 (adjust based on traffic)
   - **Idle Timeout**: 30 seconds
   - **FlashBoot**: Enabled (faster cold starts)
5. Click **Create**

### 6. Get Endpoint ID and API Key

1. Copy the **Endpoint ID** from the endpoint page
2. Go to **Settings** → **API Keys**
3. Create a new API key
4. Copy the API key

### 7. Add to Environment Variables

Add to `.env.local`:
```env
RUNPOD_API_KEY=your_api_key_here
RUNPOD_ENDPOINT_ID=your_endpoint_id_here
```

## Cost Estimates

- **A100 Spot**: ~$0.0004/second
- **3-min song**: 15-20s → $0.008-$0.012
- **30-min extension**: 90-120s → $0.048-$0.060
- **10k DAU (100k gens/day)**: ~$1,200/mo

## Testing

Test the endpoint:

```bash
curl -X POST https://api.runpod.io/v2/YOUR_ENDPOINT_ID/run \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "input": {
      "prompt": "tempo around 120-140, medium bass, clean lyrics, normal vocals, energetic",
      "duration_seconds": 30,
      "mode": "new"
    }
  }'
```

## Notes

- The handler receives the exact payload format from the PRD
- Conditioning embeddings are passed as arrays of 768 floats
- Audio is generated and returned as URL
- RunPod handles storage/upload automatically
- Mastering chain is applied before returning

