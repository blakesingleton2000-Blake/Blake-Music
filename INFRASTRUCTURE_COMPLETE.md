# Infrastructure Setup - Complete Guide

## ✅ What We Just Built

### 1. **RunPod Serverless Template** ✅
- **Dockerfile** (`runpod/Dockerfile`)
  - PyTorch base image with CUDA
  - MusicGen-large installed
  - SoX for mastering
  - Handler script ready

- **Handler Script** (`runpod/handler.py`)
  - Receives generation requests
  - Loads MusicGen model
  - Generates audio with conditioning embeddings
  - Applies mastering chain
  - Returns audio URL

- **Documentation** (`runpod/README.md`)
  - Step-by-step deployment guide
  - Docker build instructions
  - RunPod setup instructions
  - Cost estimates

### 2. **Database Migrations** ✅
- **Main Schema** (`supabase/migrations/20250107000000_initial_schema.sql`)
  - 10 tables with full schema
  - pgvector indexes
  - RLS policies
  - Functions and triggers

- **Recommendations Function** (`supabase/migrations/20250107000001_recommendations_function.sql`)
  - `match_tracks` function for pgvector queries
  - `match_embeddings` function for embedding search

- **Storage Setup** (`supabase/storage-setup.sql`)
  - Creates `audio` bucket
  - Sets up RLS policies
  - Grants permissions

### 3. **Environment Variables Template** ✅
- **Template** (`ENV_TEMPLATE.md`)
  - All required variables listed
  - Instructions for getting each key
  - Copy-paste ready format

### 4. **Deployment Guides** ✅
- **Migrations Guide** (`APPLY_MIGRATIONS_GUIDE.md`)
  - Step-by-step instructions
  - Troubleshooting tips
  - Verification queries

- **Next Steps Checklist** (`NEXT_STEPS_CHECKLIST.md`)
  - Prioritized task list
  - Checkboxes for tracking
  - Time estimates

---

## 🚀 Next Actions (In Order)

### Step 1: Apply Database Migrations ⚠️ CRITICAL

**Time**: ~5 minutes

**Action**:
1. Open `APPLY_MIGRATIONS_GUIDE.md`
2. Follow step-by-step instructions
3. Apply all 3 SQL files:
   - Main schema
   - Recommendations function
   - Storage setup

**Verify**:
```sql
-- Should return 10 tables
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' ORDER BY table_name;

-- Should return 2 functions
SELECT proname FROM pg_proc WHERE proname LIKE 'match%';

-- Should return 1 bucket
SELECT name FROM storage.buckets WHERE id = 'audio';
```

---

### Step 2: Get API Keys ⚠️ CRITICAL

**Time**: ~30 minutes

**Action**:
1. Open `ENV_TEMPLATE.md`
2. Get each API key following instructions
3. Create `app/.env.local` file
4. Fill in all values

**Required Keys**:
- ✅ Supabase (already have)
- ⏭️ RunPod (need to deploy template first)
- ⏭️ OpenAI
- ⏭️ Stripe
- ⏭️ Spotify OAuth
- ⏭️ Apple Music OAuth

---

### Step 3: Deploy RunPod Template ⚠️ HIGH PRIORITY

**Time**: ~30 minutes

**Action**:
1. Open `runpod/README.md`
2. Build Docker image:
   ```bash
   cd runpod
   docker build -t musicgen-runpod:latest .
   ```
3. Push to registry (Docker Hub or GitHub)
4. Create RunPod serverless endpoint
5. Get endpoint ID and API key
6. Add to `.env.local`

---

### Step 4: Test Locally ⚠️ HIGH PRIORITY

**Time**: ~30 minutes

**Action**:
```bash
cd app
npm install
npm run dev
```

**Test Checklist**:
- [ ] App starts without errors
- [ ] Can sign up
- [ ] Can complete onboarding
- [ ] Can generate music (if RunPod configured)
- [ ] Can play music
- [ ] Can create playlists
- [ ] Can like tracks

---

### Step 5: Deploy to Vercel ⚠️ HIGH PRIORITY

**Time**: ~15 minutes

**Action**:
1. Push code to GitHub
2. Go to https://vercel.com/new
3. Import GitHub repo
4. Set root directory: `app`
5. Add all environment variables
6. Deploy

---

## 📊 Current Status

### ✅ **Complete**:
- All app features (30+)
- Database schema (migration files ready)
- RunPod template (Dockerfile + handler)
- Storage setup (SQL ready)
- Environment template (guide ready)
- Deployment guides (step-by-step)

### 🔄 **Pending**:
- Apply migrations (5 min)
- Get API keys (30 min)
- Deploy RunPod (30 min)
- Test locally (30 min)
- Deploy to Vercel (15 min)

**Total Time**: ~2 hours

---

## 🎯 Quick Start

1. **Apply Migrations**:
   ```bash
   # Follow APPLY_MIGRATIONS_GUIDE.md
   ```

2. **Set Up Environment**:
   ```bash
   # Copy ENV_TEMPLATE.md to app/.env.local
   # Fill in all values
   ```

3. **Deploy RunPod**:
   ```bash
   # Follow runpod/README.md
   ```

4. **Test**:
   ```bash
   cd app
   npm install
   npm run dev
   ```

5. **Deploy**:
   ```bash
   # Push to GitHub
   # Connect to Vercel
   # Add env vars
   # Deploy
   ```

---

## 📚 Documentation Files

- `COMPLETE_OVERVIEW.md` - Full feature breakdown
- `APPLY_MIGRATIONS_GUIDE.md` - Database setup
- `ENV_TEMPLATE.md` - Environment variables
- `runpod/README.md` - RunPod deployment
- `NEXT_STEPS_CHECKLIST.md` - Task checklist
- `INFRASTRUCTURE_COMPLETE.md` - This file

---

**Status**: ✅ **Infrastructure Files Ready - Ready to Deploy**

