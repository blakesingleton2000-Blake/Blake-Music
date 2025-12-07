# Phase 1: Critical Items - Action Plan

## ✅ Completed (1/8)

- [x] **#4: Apply Supabase migrations** - DONE ✅

---

## 🔄 Ready to Deploy (3/8)

### #1: Deploy RunPod Serverless Template
**Status**: Files ready (`runpod/Dockerfile`, `runpod/handler.py`)  
**Time**: 30 minutes  
**Action**: 
1. Build Docker image
2. Push to registry
3. Create RunPod endpoint
4. Get API keys
5. Add to `.env.local`

**See**: `runpod/README.md`

---

### #5: Deploy Daily Counter Reset Edge Function
**Status**: Code ready (`supabase/functions/reset-daily-count/`)  
**Time**: 10 minutes  
**Action**:
```bash
cd supabase
supabase functions deploy reset-daily-count
```
Then set up cron job in Supabase Dashboard

**See**: `DEPLOY_EDGE_FUNCTION.md`

---

### #7: Verify Supabase Storage Bucket
**Status**: SQL already in migration  
**Time**: 2 minutes  
**Action**:
1. Go to Supabase Dashboard → Storage
2. Verify `audio` bucket exists
3. Check permissions

---

## ⚠️ Needs Implementation (4/8)

### #6: Implement Mastering Chain
**Status**: Placeholder exists, needs SoX + pydub  
**Time**: 4-6 hours  
**Priority**: HIGH (audio quality)  
**Action**:
- Updated `runpod/handler.py` with ffmpeg mastering
- Uses `loudnorm` filter for -14 LUFS
- Adds compression and exciter
- **Status**: Code updated, needs testing

---

### #8: Add Voice Preset WAV Files
**Status**: Not started  
**Time**: 1 hour  
**Priority**: MEDIUM (can use defaults)  
**Action**:
- Generate/obtain 12 WAV files
- Upload to Supabase Storage
- Update code to reference them
- **For MVP**: Can skip, use default MusicGen vocals

**See**: `add-voice-presets.md`

---

### #9: Add PostHog Analytics
**Status**: Not started  
**Time**: 4 hours  
**Priority**: MEDIUM (can add later)  
**Action**:
- Set up PostHog account
- Add SDK to app
- Track key events
- Set up dashboards

**See**: `add-posthog.tsx` (code ready)

---

## 🎯 Recommended Order

### Today (2 hours):
1. ✅ Deploy RunPod template (30 min)
2. ✅ Deploy Edge Function (10 min)
3. ✅ Verify Storage bucket (2 min)
4. ⏭️ Test app locally (30 min)
5. ⏭️ Get OpenAI key (5 min)

### This Week (10 hours):
6. ⏭️ Implement mastering chain (4-6 hours)
7. ⏭️ Add PostHog (4 hours)
8. ⏭️ Add voice presets (1 hour) - Optional

---

## 📊 Progress

**Phase 1**: 1/8 complete (12.5%)  
**Ready to Deploy**: 3 items  
**Needs Implementation**: 4 items

**Estimated Remaining**: ~12-15 hours

---

Let's start with the quick wins (RunPod + Edge Function)!

