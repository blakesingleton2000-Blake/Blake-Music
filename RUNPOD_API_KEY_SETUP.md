# RunPod API Key Setup

## 🔑 Two Different Keys

RunPod has **two different types of keys**:

1. **API Key** (for making REST API calls) - What we need
2. **Secret** (for use inside pods/endpoints) - What you showed me

## ✅ What You Need: API Key

For making API calls from your Next.js app to RunPod, you need the **API Key**, not the Secret.

### How to Get Your API Key:

1. Go to [RunPod Dashboard](https://www.runpod.io/)
2. Navigate to **Settings** → **API Keys** (NOT Secrets)
3. Look for a section that says **"API Keys"** or **"Personal API Keys"**
4. If you don't have one, click **"Create API Key"** or **"Generate API Key"**
5. Copy the key (it's usually a long string, like `ABC123XYZ...`)

**Note**: The API key is different from the Secret ID (`uc0ju6sxb5`) you showed me. The Secret is for use inside RunPod pods, but the API Key is for external API calls.

## 📝 Once You Have the API Key

### Add to `app/.env.local`:

```env
RUNPOD_API_KEY=your_actual_api_key_here
RUNPOD_ENDPOINT_ID=60f1l3y3ck0sp2
RUNPOD_API_URL=https://api.runpod.io/v2
```

### Add to Vercel:

1. Go to Vercel Dashboard → Your Project → Settings → Environment Variables
2. Add:
   - **Key**: `RUNPOD_API_KEY`
   - **Value**: Your actual API key
   - **Environment**: Production, Preview, Development (select all)
3. Add:
   - **Key**: `RUNPOD_ENDPOINT_ID`
   - **Value**: `60f1l3y3ck0sp2`
   - **Environment**: Production, Preview, Development
4. Add:
   - **Key**: `RUNPOD_API_URL`
   - **Value**: `https://api.runpod.io/v2`
   - **Environment**: Production, Preview, Development

## 🧪 Test Your API Key

Once you have the API key, test it:

```bash
curl -X POST https://api.runpod.io/v2/60f1l3y3ck0sp2/run \
  -H "Authorization: Bearer YOUR_API_KEY_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "input": {
      "prompt": "test music generation",
      "duration_seconds": 30,
      "mode": "new"
    }
  }'
```

If it works, you'll get a response like:
```json
{
  "id": "job-abc123xyz",
  "status": "IN_QUEUE"
}
```

## 🔍 Can't Find API Keys Section?

If you don't see an "API Keys" section in Settings:

1. Check if you're on the right page: **Settings** → **API Keys** (not Secrets)
2. Some accounts might need to enable API access first
3. Try looking for **"Personal API Keys"** or **"Access Tokens"**
4. Contact RunPod support if you can't find it

## ⚠️ Important Notes

- **API Key** = For external API calls (what we need)
- **Secret** = For use inside RunPod pods/endpoints (not what we need)
- Keep your API key secure - never commit it to git
- Rotate your API key if exposed

## ✅ Quick Checklist

- [ ] Found Settings → API Keys in RunPod dashboard
- [ ] Created/copied your API key
- [ ] Added to `app/.env.local`
- [ ] Added to Vercel environment variables
- [ ] Tested with curl command above

Once you have the API key, your music generation will be fully connected! 🚀

