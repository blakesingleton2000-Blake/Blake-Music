# ⚡ Quick Start - 5 Minute Setup

## Fastest Path to Running the App

### Option A: Test Without RunPod (Quick Test)

1. **Apply Database Migrations** (2 min):
   - Go to: https://djszkpgtwhdjhexnjdof.supabase.co
   - SQL Editor → New Query
   - Copy/paste `supabase/migrations/20250107000000_initial_schema.sql` → Run
   - Copy/paste `supabase/storage-setup.sql` → Run

2. **Set Up Environment** (2 min):
   ```bash
   cd app
   # Create .env.local with just Supabase keys (you already have these)
   ```

3. **Run Locally** (1 min):
   ```bash
   npm install
   npm run dev
   ```

**Result**: App runs, but music generation won't work (needs RunPod)

---

### Option B: Full Setup (2 Hours)

Follow `START_HERE.md` for complete setup with all features working.

---

## What Works Without RunPod?

✅ Sign up / Login  
✅ Onboarding  
✅ Create playlists  
✅ Like tracks  
✅ Search  
✅ Library  
✅ Settings  
✅ OAuth connections  
❌ Music generation (needs RunPod)  
❌ Audio playback (needs generated tracks)

---

## Recommended: Start with Option A

Test the UI/UX first, then add RunPod for full functionality.
