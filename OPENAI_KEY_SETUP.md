# OpenAI API Key Setup ✅

## 📝 Where to Add Your API Key

### 1. Local Development (`app/.env.local`)

Add this line to `app/.env.local`:

```env
OPENAI_API_KEY=YOUR_OPENAI_API_KEY
```

### 2. Vercel Production

1. Go to Vercel Dashboard → Your Project → Settings → Environment Variables
2. Click "Add New"
3. Add:
   - **Key**: `OPENAI_API_KEY`
   - **Value**: `YOUR_OPENAI_API_KEY`
   - **Environment**: Production, Preview, Development (select all)
4. Click "Add"

## 🎯 What This Enables

With OpenAI API key configured, you get:

- ✅ **"Because you like X..." explanations** - AI-generated explanations for recommendations
- ✅ **Screenshot OCR** - Parse screenshots to import playlists
- ✅ **Band name/bio generation** - Auto-generate band names and bios
- ✅ **Smart descriptions** - Enhanced track descriptions

## 🔐 Security Notes

- ⚠️ **Never commit** this key to git (already in `.gitignore`)
- 🔒 Keep this key secure
- 🔄 Rotate if exposed
- 💰 Monitor usage at https://platform.openai.com/usage

## ✅ Next Steps

1. Add to `app/.env.local` for local testing
2. Add to Vercel for production
3. Test screenshot import feature
4. Test explanation generation

---

**Status**: ✅ Ready to add API key to environment variables!
