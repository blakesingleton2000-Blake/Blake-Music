# 🚀 Start Deployment Now

## Quick Start (5 Steps)

### Step 1: Start Docker Desktop
- Open Docker Desktop app
- Wait for it to start (whale icon in menu bar)

### Step 2: Login to Supabase CLI
```bash
supabase login
```
(Opens browser for authentication)

### Step 3: Deploy RunPod Template
```bash
./deploy-runpod.sh
```

This will:
- Build Docker image
- Guide you through tagging/pushing
- Show you how to create RunPod endpoint

### Step 4: Deploy Edge Function
```bash
./deploy-edge-function.sh
```

This will:
- Deploy the function
- Show you how to set up cron job

### Step 5: Add API Keys
After RunPod deployment, add to `app/.env.local`:
```env
RUNPOD_API_KEY=your_key
RUNPOD_ENDPOINT_ID=your_endpoint_id
```

---

## ⚡ Fastest Path

1. **Start Docker Desktop** (if not running)
2. **Run**: `supabase login` (if not logged in)
3. **Run**: `./deploy-runpod.sh`
4. **Follow prompts** to push image and create endpoint
5. **Run**: `./deploy-edge-function.sh`
6. **Set up cron** in Supabase Dashboard

**Total time**: ~30 minutes

---

## 🆘 Troubleshooting

### "Docker daemon not running"
- Start Docker Desktop
- Wait for it to fully start

### "Not logged in to Supabase"
- Run `supabase login`
- Complete browser authentication

### "Docker Hub login failed"
- Make sure you have Docker Hub account
- Or use GitHub Container Registry instead

---

**Ready? Start with Docker Desktop, then run the scripts!** 🚀

