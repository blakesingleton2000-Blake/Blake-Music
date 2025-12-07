# RunPod Serverless Template Setup

## Overview

This document describes how to set up the RunPod serverless endpoint for MusicGen-large generation, following the exact specifications from the PRD.

## Dockerfile

Create `runpod/Dockerfile`:

```dockerfile
FROM pytorch/pytorch:2.4.0-cuda12.1-cudnn8-runtime

RUN pip install musicgen-large chatterbox-tts torchaudio

COPY handler.py /app/handler.py

CMD ["python", "/app/handler.py"]
```

## Handler Script

Create `runpod/handler.py`:

```python
import json
import os
from musicgen import MusicGen
import torch

model = None

def handler(event):
    global model
    
    # Load model on first request
    if model is None:
        model = MusicGen.get_pretrained('facebook/musicgen-large')
        model.set_generation_params(duration=180)
    
    # Parse input
    input_data = event.get('input', {})
    
    conditioning_embedding = input_data.get('conditioning_embedding')
    prompt = input_data.get('prompt', '')
    duration_seconds = input_data.get('duration_seconds', 180)
    voice_preset = input_data.get('voice_preset')
    exaggeration = input_data.get('exaggeration', 0.8)
    mode = input_data.get('mode', 'new')
    source_id = input_data.get('source_id')
    
    # Generate audio
    if conditioning_embedding:
        # Use conditioning embedding
        audio = model.generate_with_conditioning(
            conditioning_embedding,
            prompt=prompt,
            duration=duration_seconds
        )
    else:
        # Generate from prompt only
        audio = model.generate([prompt], duration=duration_seconds)
    
    # Save audio to temporary file
    output_path = f'/tmp/output_{source_id or "new"}.wav'
    torchaudio.save(output_path, audio, sample_rate=32000)
    
    # Upload to storage (S3, Supabase, etc.)
    # For now, return local path (RunPod handles upload)
    
    return {
        'status': 'COMPLETED',
        'output': {
            'audio_url': output_path,  # RunPod will handle upload
            'duration': duration_seconds
        }
    }
```

## Deployment Steps

1. **Build Docker Image**:
   ```bash
   docker build -t musicgen-runpod .
   ```

2. **Push to Container Registry**:
   ```bash
   docker tag musicgen-runpod your-registry/musicgen-runpod
   docker push your-registry/musicgen-runpod
   ```

3. **Create RunPod Serverless Endpoint**:
   - Go to RunPod dashboard
   - Create new serverless endpoint
   - Use A100 GPU
   - Set container image to your registry image
   - Configure environment variables

4. **Get Endpoint ID**:
   - Copy the endpoint ID from RunPod dashboard
   - Add to `.env.local`: `RUNPOD_ENDPOINT_ID=your-endpoint-id`

5. **Get API Key**:
   - Generate API key in RunPod dashboard
   - Add to `.env.local`: `RUNPOD_API_KEY=your-api-key`

## Cost Estimates

- **3-min song**: 15-20s on A100 spot → $0.008-$0.012
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
      "duration_seconds": 180,
      "mode": "new"
    }
  }'
```

## Notes

- The handler receives the exact payload format from the PRD
- Conditioning embeddings are passed as arrays
- Audio is generated and returned as URL
- RunPod handles the actual storage/upload

