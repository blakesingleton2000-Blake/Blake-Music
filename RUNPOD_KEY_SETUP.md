# RunPod API Key Setup ✅

## 📝 Where to Add Your API Key

### 1. Local Development (`app/.env.local`)

Add these lines to `app/.env.local`:

```env
RUNPOD_API_KEY=YOUR_RUNPOD_API_KEY
RUNPOD_ENDPOINT_ID=60f1l3y3ck0sp2
RUNPOD_API_URL=https://api.runpod.io/v2
```

### 2. Vercel Production

1. Go to Vercel Dashboard → Your Project → Settings → Environment Variables
2. Add each variable:

**Variable 1:**
- **Key**: `RUNPOD_API_KEY`
- **Value**: `YOUR_RUNPOD_API_KEY`
- **Environment**: Production, Preview, Development (select all)

**Variable 2:**
- **Key**: `RUNPOD_ENDPOINT_ID`
- **Value**: `60f1l3y3ck0sp2`
- **Environment**: Production, Preview, Development

**Variable 3:**
- **Key**: `RUNPOD_API_URL`
- **Value**: `https://api.runpod.io/v2`
- **Environment**: Production, Preview, Development

3. Click "Add" for each
4. **Redeploy** your Vercel app to activate

## 🧪 Test Your Connection

Once added, test the endpoint:

```bash
curl -X POST https://api.runpod.io/v2/60f1l3y3ck0sp2/run \
  -H "Authorization: Bearer YOUR_RUNPOD_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "input": {
      "prompt": "test music generation",
      "duration_seconds": 30,
      "mode": "new"
    }
  }'
```

Expected response:
```json
{
  "id": "job-abc123xyz",
  "status": "IN_QUEUE"
}
```

Then check status:
```bash
curl https://api.runpod.io/v2/60f1l3y3ck0sp2/status/job-abc123xyz \
  -H "Authorization: Bearer YOUR_RUNPOD_API_KEY"
```

## ✅ Code Verification

The code is already configured correctly:

- ✅ Uses `Bearer` token authentication
- ✅ Correct API endpoints (`/v2/{endpoint_id}/run` and `/v2/{endpoint_id}/status/{job_id}`)
- ✅ Proper payload format matching RunPod serverless handler
- ✅ Error handling and retry logic included

**No code changes needed** - just add the environment variables!

## 🎯 What This Enables

With RunPod configured, you get:

- ✅ **AI Music Generation** - Generate music with MusicGen-large
- ✅ **4 Generation Modes** - New, Similar, Extend, Radio
- ✅ **Real-time Status** - Poll job status until completion
- ✅ **Mastered Audio** - ffmpeg + SoX mastering chain
- ✅ **MP3 Output** - Compressed audio format

## 🔐 Security Notes

- ⚠️ **Never commit** this key to git (already in `.gitignore`)
- 🔒 Keep this key secure
- 🔄 Rotate if exposed
- 💰 Monitor usage at RunPod Dashboard

## ✅ Next Steps

1. ✅ Add to `app/.env.local` for local testing
2. ✅ Add to Vercel for production
3. ✅ Redeploy Vercel
4. ⏳ Deploy handler code to RunPod endpoint (if not already done)
5. ⏳ Test music generation from your app

---

**Status**: ✅ Ready to add API key to environment variables!
