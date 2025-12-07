# Remaining Work Based on All PRDs

## ✅ What's Actually Complete (Verified)

### Core Features
- ✅ Database schema (10 tables + functions)
- ✅ Authentication (email + Google OAuth)
- ✅ Onboarding flow (3 steps: Genres → Artists → Preferences)
- ✅ Home screen with categories
- ✅ Search screen with autosuggest
- ✅ Library screen with filters
- ✅ Generate page with 4 modes (new, similar, extend, radio)
- ✅ Full Player component (with waveform, controls)
- ✅ Mini Player component
- ✅ RunPod integration (API client ready)
- ✅ OAuth connections (Spotify + Apple Music)
- ✅ Settings page
- ✅ All core API routes

### Advanced Features
- ✅ Screenshot OCR import (`/api/ingest-screenshot`)
- ✅ TuneMyMusic import (`/api/ingest-tunemymusic`)
- ✅ Band auto-creation logic (`lib/band-creation.ts`)
- ✅ Infinite Radio pre-generation (`lib/infinite-radio.ts`)
- ✅ Taste vector computation (`lib/taste-vector.ts`)
- ✅ Recommendations engine (`/api/categories` with pgvector)
- ✅ Stripe payments (checkout, webhook, premium page)
- ✅ Error boundaries (`components/ErrorBoundary.tsx`)
- ✅ Retry logic (`lib/retry.ts`)
- ✅ Error handling (`lib/error-handler.ts`)
- ✅ Audio storage (`lib/audio-storage.ts`)

---

## 🔴 Critical - Must Do Before Launch

### 1. **Add All Real API Keys to Vercel/Supabase Environment Variables** ⚠️ BLOCKER
**Status**: App runs on placeholders  
**Action Required**: Add all environment variables to Vercel Dashboard and Supabase:

**Vercel Environment Variables**:
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`
- `OPENAI_API_KEY`
- `RUNPOD_API_KEY`
- `RUNPOD_ENDPOINT_ID`
- `STRIPE_SECRET_KEY`
- `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY`
- `STRIPE_WEBHOOK_SECRET`
- `SPOTIFY_CLIENT_ID`
- `SPOTIFY_CLIENT_SECRET`
- `APPLE_MUSIC_KEY_ID` (optional)
- `APPLE_MUSIC_TEAM_ID` (optional)
- `APPLE_MUSIC_PRIVATE_KEY` (optional)
- `NEXT_PUBLIC_APP_URL`

**Supabase Environment Variables** (for Edge Functions):
- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`

**Why Critical**: Generation, search, OAuth, payments won't work in production without real keys.

**Time**: 30-60 minutes

**Guide**: See `ENV_TEMPLATE.md` for instructions on obtaining each key.

---

### 2. **Deploy RunPod Serverless Endpoint (MusicGen-large)** ⚠️ BLOCKER
**Status**: Not deployed  
**Files**: `runpod/Dockerfile`, `runpod/handler.py`  
**Action Required**:
1. Build Docker image: `docker build -t musicgen-runpod:latest ./runpod`
2. Push to Docker Hub: `docker push YOUR_USERNAME/musicgen-runpod:latest`
3. Create RunPod endpoint in console (A100 GPU)
4. Add `RUNPOD_API_KEY` and `RUNPOD_ENDPOINT_ID` to Vercel

**Why Critical**: Music generation will fail without the GPU worker.

**Time**: 1-2 hours

**Guide**: See `RUNPOD_SETUP.md` and `deploy-runpod.sh`

---

### 3. **Apply Supabase Migrations in Production DB** ⚠️ BLOCKER
**Status**: Not applied  
**Files**: 
- `supabase/migrations/20250107000000_initial_schema.sql`
- `supabase/migrations/20250107000001_recommendations_function.sql`

**Action Required**: 
- Option 1: Run in Supabase SQL Editor (copy/paste SQL)
- Option 2: Use Supabase CLI: `supabase db push`

**Why Critical**: Tables/functions don't exist in live DB yet.

**Time**: 15 minutes

**Guide**: See `APPLY_MIGRATIONS_GUIDE.md` or use `combined-migration.sql` for one-shot setup.

---

### 4. **Deploy Daily Counter Reset Edge Function + Cron Job** ⚠️ BLOCKER
**Status**: Not deployed  
**File**: `supabase/functions/reset-daily-count/index.ts`  
**Action Required**:
```bash
cd supabase
supabase functions deploy reset-daily-count --no-verify-jwt
```
Then set up cron job in Supabase Dashboard:
- Schedule: `0 0 * * *` (midnight UTC daily)
- Function: `reset-daily-count`
- Method: `GET`

**Why Critical**: Free users get unlimited generations without this.

**Time**: 30 minutes (15 min deploy + 15 min cron setup)

**Guide**: See `DEPLOY_EDGE_FUNCTION_FINAL.md`

---

### 5. **Set Up Supabase Storage Bucket "audio" with Signed URLs** ⚠️ BLOCKER
**Status**: Not created  
**File**: `supabase/storage-setup.sql`

**Action Required**: 
1. Run SQL script in Supabase SQL Editor to create `audio` bucket
2. Verify RLS policies are applied
3. Test upload/download in Supabase Dashboard

**Why Critical**: Audio uploads/streaming fail without this.

**Time**: 15 minutes

**Guide**: See `supabase/storage-setup.sql`

---

## 🟡 Important - Should Do Before Launch

### 5. **PostHog Analytics Integration** ⚠️ HIGH PRIORITY
**Status**: Not implemented  
**PRD Requirement**: Track retention, ratings, play time

**What's Missing**:
- PostHog SDK setup
- Event tracking (generation, play, like, etc.)
- Retention dashboards
- "Sounds like me" rating modal

**Files to Create**:
- `app/lib/posthog.ts` (PostHog client)
- Add PostHogProvider to `app/layout.tsx`
- Add event tracking throughout app

**Time**: 2-3 hours

**Note**: PRD mentions self-hosting PostHog, but cloud version is fine for MVP.

---

### 6. **YouTube OAuth Integration** ⚠️ MEDIUM PRIORITY
**Status**: Not implemented  
**PRD Requirement**: Multi-platform support (Apple/YouTube priority)

**What's Missing**:
- `/api/connect/youtube` route
- YouTube Data API v3 integration
- Playlist import from YouTube
- Watch history import

**Time**: 2-3 hours

**Note**: PRD says "Apple/YouTube first (no quotas)" - Apple is done, YouTube is missing.

---

### 7. **Voice Preset WAV Files** ⚠️ MEDIUM PRIORITY
**Status**: Not added  
**PRD Requirement**: 12 voice preset WAV files for Chatterbox TTS

**What's Missing**:
- Upload 12 preset WAV files to Supabase Storage
- Update RunPod handler to use presets
- Add preset selection UI in generate modal

**Time**: 1 hour (if files exist)

**Note**: PRD mentions these are for podcast/explainer side, but music side may use them too.

---

### 8. **MusicBrainz Rate-Limit Backoff + Top-200k Cache** ⚠️ MEDIUM PRIORITY
**Status**: Not implemented  
**PRD Requirement**: Handle MusicBrainz 1 req/sec rate limit + cache top 200k tracks

**What's Missing**:
- Rate-limit queue for MusicBrainz API calls (1 req/sec)
- Exponential backoff on 429 errors
- Top-200k track cache (pre-populate embeddings table)
- Cache warming script
- Fallback to cached results when rate-limited

**Why Important**: Search will 429 under load without proper rate limiting and caching.

**Time**: 4 hours

**Note**: Critical if using MusicBrainz for autosuggest/search. Consider pre-populating embeddings table with top tracks.

---

### 9. **Generation Timeout/Progress UX** ⚠️ LOW PRIORITY
**Status**: Basic progress exists, could be better  
**PRD Requirement**: "Cool loading UI" with animated waveform

**What's Missing**:
- Better progress indicators
- Animated waveform during generation
- Timeout handling (if generation takes >2 minutes)
- Cancel generation button

**Time**: 3-4 hours

**Note**: Current implementation has basic progress bar, but PRD mentions "cool loading UI" for V2.

---

## 🟢 Nice-to-Have - Can Add Later

### 10. **Explore Feed (Reels-Style)**
**Status**: Not implemented  
**PRD Requirement**: Vertical scroll feed with 15-30s clips

**What's Missing**:
- `/explore` page
- Reels-style vertical scroll
- Community-generated tracks feed
- Remix functionality

**Time**: 6-8 hours

**Note**: PRD mentions this but says it's for V2/community features.

---

### 11. **Implement Mastering Chain (SoX + pydub)** ⚠️ MEDIUM PRIORITY
**Status**: Implemented with ffmpeg, needs verification  
**File**: `runpod/handler.py` (mastering_chain function)

**Current Implementation**: Uses `ffmpeg` with `loudnorm` filter (equivalent to SoX)
- Normalizes to -14 LUFS
- Applies compression
- Applies exciter (treble boost)

**What's Missing**:
- Test mastering chain output in production
- Verify -14 LUFS normalization is correct
- Test compression and exciter effects
- Compare before/after audio quality
- Consider switching to SoX + pydub if ffmpeg doesn't meet quality standards

**Time**: 4-6 hours (if switching to SoX + pydub) or 1-2 hours (if just testing current implementation)

**Note**: PRD specifies SoX + pydub, but current implementation uses ffmpeg which should work similarly. May need to switch if quality isn't acceptable.

---

### 12. **Band Cover Generation**
**Status**: Placeholder (null cover_url)  
**PRD Requirement**: Midjourney/Stable Diffusion for band covers

**What's Missing**:
- Integrate Midjourney API or Stable Diffusion
- Generate covers when bands are created
- Upload to Supabase Storage

**Time**: 2-3 hours

**Note**: PRD mentions Midjourney API, but Stable Diffusion is cheaper.

---

### 13. **Offline Caching (Premium)**
**Status**: Not implemented  
**PRD Requirement**: Cache 5-10 tracks for offline playback (premium)

**What's Missing**:
- Service Worker setup
- Cache API integration
- Offline detection
- Cache management UI

**Time**: 4-6 hours

**Note**: PRD mentions this for premium users, but not critical for MVP.

---

### 14. **Accessibility Improvements**
**Status**: Basic, needs enhancement  
**PRD Requirement**: VoiceOver, haptics, high-contrast mode

**What's Missing**:
- ARIA labels throughout
- Keyboard navigation
- Screen reader support
- High-contrast mode toggle
- Haptic feedback (mobile)

**Time**: 4-6 hours

**Note**: Important for accessibility compliance.

---

### 15. **Player Gestures, Background Play, Offline (Device-Specific)** ⚠️ MEDIUM PRIORITY
**Status**: Not implemented  
**PRD Requirement**: Player gestures, background play, offline caching (only show on device)

**What's Missing**:
- **Player Gestures**:
  - Swipe to dismiss player
  - Swipe left/right for queue navigation
  - Pull down to minimize
  - Long-press for context menu
- **Background Play**:
  - Continue playing when app is backgrounded
  - Media session API integration
  - Lock screen controls
  - Notification controls
- **Offline Mode**:
  - Only show offline option on mobile devices
  - Service Worker for offline caching
  - Cache 5-10 tracks (premium)
  - Offline indicator in UI

**Time**: 1-2 days

**Note**: These are device-specific features. Web app can use Media Session API for background play, but full offline requires Service Worker + Cache API.

---

### 16. **Mobile Responsiveness Testing**
**Status**: Desktop-first, needs mobile testing  
**PRD Requirement**: React Native mentioned, but we built Next.js web app

**What's Missing**:
- Test on mobile devices
- Fix touch gestures
- Optimize layouts for small screens
- Test on iOS Safari and Android Chrome

**Time**: 2-3 hours

**Note**: PRD mentions React Native, but we built Next.js web app. Mobile web testing is still needed.

---

## 📊 Testing & Quality Assurance

### 17. **End-to-End Testing** ⚠️ HIGH PRIORITY
**Status**: Not done  
**What to Test**:
- Complete user flow (signup → onboard → generate → play)
- OAuth connections (Spotify, Apple Music)
- Import flows (screenshot, TuneMyMusic)
- Playlist creation/editing
- Like/Unlike functionality
- Recommendations
- Infinite Radio mode
- Band auto-creation

**Time**: 3-4 hours

---

### 18. **Error Scenario Testing**
**Status**: Not done  
**What to Test**:
- Network failures
- API timeouts
- Invalid user input
- Missing environment variables
- Database errors
- Storage failures

**Time**: 2-3 hours

---

## 🎯 Priority Summary

### **Phase 1: Critical Blockers (Do First - 3-4 hours)**
1. ✅ Add All Real API Keys to Vercel/Supabase (30-60 min)
2. ✅ Deploy RunPod Serverless Endpoint (1-2 hours)
3. ✅ Apply Supabase Migrations in Production DB (15 min)
4. ✅ Deploy Daily Counter Reset Edge Function + Cron (30 min)
5. ✅ Set Up Supabase Storage Bucket (15 min)

### **Phase 2: Important Features (Do Next - 8-12 hours)**
6. ✅ PostHog Analytics (2-3 hours)
7. ✅ YouTube OAuth (2-3 hours)
8. ✅ MusicBrainz Rate-Limit + Cache (4 hours)
9. ✅ Implement Mastering Chain Testing/Switch (4-6 hours)
10. ✅ End-to-End Testing (3-4 hours)

### **Phase 3: Polish & Nice-to-Have (Can Do Later)**
11. ✅ Voice Preset Files (1 hour)
12. ✅ Generation Progress UX (3-4 hours)
13. ✅ Player Gestures, Background Play, Offline (1-2 days)
14. ✅ Explore Feed (6-8 hours)
15. ✅ Band Cover Generation (2-3 hours)
16. ✅ Offline Caching (4-6 hours)
17. ✅ Accessibility (4-6 hours)
18. ✅ Mobile Testing (2-3 hours)

---

## 📋 Action Plan

### **Before First Public Launch** (Must Complete Phase 1)
1. Add All Real API Keys to Vercel/Supabase
2. Deploy RunPod Serverless Endpoint
3. Apply Supabase Migrations in Production DB
4. Deploy Daily Counter Reset Edge Function + Cron
5. Set Up Supabase Storage Bucket

**Total Time**: 3-4 hours

### **Before Full Launch** (Should Complete Phase 2)
6. Add PostHog Analytics
7. Add YouTube OAuth
8. Implement MusicBrainz Rate-Limit + Cache
9. Test/Switch Mastering Chain (SoX + pydub)
10. Complete End-to-End Testing

**Total Time**: 13-18 hours

### **Post-Launch** (Can Add Phase 3 Features)
8-15. All nice-to-have features

**Total Time**: 20-30 hours

---

## ✅ Summary

**Current Status**: ~95% Complete

**Critical Blockers**: 5 items (3-4 hours)
**Important Features**: 5 items (13-18 hours)
**Nice-to-Have**: 8 items (20-30 hours)

**Total Remaining**: ~36-52 hours of work

**Recommendation**: 
1. Complete Phase 1 (blockers) → Launch MVP
2. Complete Phase 2 (important) → Full Launch
3. Add Phase 3 (polish) → Iterate based on feedback

---

## 🚀 Quick Start Checklist

### Critical (Must Do First)
- [ ] Add all real API keys to Vercel/Supabase environment variables
- [ ] Deploy RunPod serverless endpoint (MusicGen-large)
- [ ] Apply Supabase migrations in production DB
- [ ] Deploy daily counter reset Edge Function + cron job
- [ ] Set up Supabase Storage bucket (`audio`) with signed URLs

### Important (Do Next)
- [ ] Add PostHog SDK and event tracking
- [ ] Add YouTube OAuth integration
- [ ] Implement MusicBrainz rate-limit backoff + top-200k cache
- [ ] Test/implement mastering chain (SoX + pydub)
- [ ] Complete end-to-end testing

### Nice-to-Have (Can Do Later)
- [ ] Improve generation progress UX
- [ ] Add player gestures, background play, offline mode
- [ ] Build Explore Feed (Reels-style)
- [ ] Add band cover generation
- [ ] Implement offline caching (premium)
- [ ] Improve accessibility
- [ ] Test mobile responsiveness

### Deployment
- [ ] Deploy to Vercel
- [ ] Verify all environment variables are set
- [ ] Test in production
- [ ] Monitor error logs

**You're almost there!** 🎉

