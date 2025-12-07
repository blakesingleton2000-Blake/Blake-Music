# 🚀 Deploy to Vercel NOW

## You're Already Logged In! ✅

**Username**: blakesingleton-6188

---

## Quick Deploy (Choose One)

### Option 1: Deploy via CLI (Fastest)

```bash
cd app
vercel --prod --yes
```

This will:
- Deploy to production
- Auto-detect Next.js
- Give you a live URL

**Then add environment variables** (see below)

---

### Option 2: Deploy via Dashboard (More Control)

1. **Push to GitHub** (if not already):
   ```bash
   git add .
   git commit -m "Ready for Vercel"
   git push origin main
   ```

2. **Go to**: https://vercel.com/new
3. **Import** your GitHub repo
4. **Configure**:
   - Root Directory: `app` ⚠️ **CRITICAL**
   - Framework: Next.js (auto)
5. **Add environment variables** (see below)
6. **Deploy**!

---

## Environment Variables to Add

**In Vercel Dashboard** → Settings → Environment Variables:

### Required:
```env
NEXT_PUBLIC_SUPABASE_URL=https://djszkpgtwhdjhexnjdof.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here
```

### For Music Generation (add after RunPod):
```env
RUNPOD_API_KEY=your_key
RUNPOD_ENDPOINT_ID=your_endpoint_id
```

### Optional (can add later):
```env
OPENAI_API_KEY=your_key
STRIPE_SECRET_KEY=your_key
```

---

## ⚠️ Critical: Root Directory

**MUST SET**: Root Directory = `app`

In Vercel Dashboard:
- Settings → General → Root Directory: `app`

---

## After Deployment

1. ✅ Get your live URL
2. ✅ Test the app
3. ⏭️ Add environment variables
4. ⏭️ Deploy RunPod (separate, for music generation)

---

## Run Now

```bash
cd app
vercel --prod --yes
```

Then add env vars in dashboard! 🚀
