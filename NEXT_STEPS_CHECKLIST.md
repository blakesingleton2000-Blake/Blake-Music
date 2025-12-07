# Next Steps Checklist

## ✅ Completed

- [x] Database schema created (migration files ready)
- [x] Frontend app built (all features)
- [x] API routes implemented
- [x] RunPod handler created
- [x] Dockerfile created
- [x] Environment variables template created
- [x] Storage setup SQL created

## 🔄 Next Steps (In Order)

### 1. Apply Database Migrations ⚠️ CRITICAL

**Status**: Files ready, needs to be run

**Files**:
- `supabase/migrations/20250107000000_initial_schema.sql`
- `supabase/migrations/20250107000001_recommendations_function.sql`
- `supabase/storage-setup.sql`

**Action**:
- Follow `APPLY_MIGRATIONS_GUIDE.md`
- Takes ~5 minutes

**Checklist**:
- [ ] Applied main schema migration
- [ ] Applied recommendations function
- [ ] Set up storage bucket
- [ ] Verified all tables exist
- [ ] Verified functions exist

---

### 2. Get API Keys ⚠️ CRITICAL

**Required Keys**:

#### RunPod
- [ ] Create RunPod account
- [ ] Deploy serverless template (see `runpod/README.md`)
- [ ] Get API key
- [ ] Get endpoint ID

#### OpenAI
- [ ] Create OpenAI account
- [ ] Get API key from https://platform.openai.com/api-keys

#### Stripe
- [ ] Create Stripe account
- [ ] Get test API keys
- [ ] Create products/prices
- [ ] Get price IDs
- [ ] Set up webhook endpoint

#### Spotify OAuth
- [ ] Create Spotify Developer account
- [ ] Create app at https://developer.spotify.com/dashboard
- [ ] Get client ID and secret
- [ ] Add redirect URI: `http://localhost:3000/api/connect/spotify/callback`

#### Apple Music OAuth
- [ ] Create Apple Developer account
- [ ] Create MusicKit key
- [ ] Get team ID, key ID, private key

---

### 3. Set Up Environment Variables ⚠️ CRITICAL

**Action**:
1. Copy `app/.env.local.example` to `app/.env.local`
2. Fill in all values
3. Add to Vercel environment variables (for production)

**Checklist**:
- [ ] Created `.env.local` file
- [ ] Added Supabase keys
- [ ] Added RunPod keys
- [ ] Added OpenAI key
- [ ] Added Stripe keys
- [ ] Added OAuth credentials
- [ ] Added to Vercel (for production)

---

### 4. Deploy RunPod Serverless Template ⚠️ HIGH PRIORITY

**Action**:
- Follow `runpod/README.md`
- Build Docker image
- Push to registry
- Create RunPod endpoint

**Checklist**:
- [ ] Built Docker image
- [ ] Pushed to registry
- [ ] Created RunPod template
- [ ] Created endpoint
- [ ] Tested endpoint
- [ ] Added endpoint ID to env vars

---

### 5. Deploy Edge Function ⚠️ MEDIUM PRIORITY

**Action**:
```bash
cd supabase
supabase functions deploy reset-daily-count
```

**Then**:
- Go to Supabase Dashboard → Database → Cron Jobs
- Create cron job:
  - Schedule: `0 0 * * *` (midnight UTC)
  - Function: `reset-daily-count`

**Checklist**:
- [ ] Deployed Edge Function
- [ ] Created cron job
- [ ] Tested function manually

---

### 6. Test Locally ⚠️ HIGH PRIORITY

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
- [ ] Can search
- [ ] Can import music
- [ ] Can connect OAuth

---

### 7. Deploy to Vercel ⚠️ HIGH PRIORITY

**Action**:
1. Push code to GitHub
2. Go to https://vercel.com/new
3. Import GitHub repo
4. Set root directory: `app`
5. Add all environment variables
6. Deploy

**Checklist**:
- [ ] Code pushed to GitHub
- [ ] Vercel project created
- [ ] Root directory set to `app`
- [ ] All env vars added
- [ ] Deployed successfully
- [ ] Tested production URL

---

### 8. Set Up Stripe Webhook ⚠️ MEDIUM PRIORITY

**Action**:
1. Go to Stripe Dashboard → Webhooks
2. Add endpoint: `https://your-domain.com/api/stripe/webhook`
3. Select events:
   - `checkout.session.completed`
   - `customer.subscription.deleted`
4. Copy webhook secret
5. Add to environment variables

**Checklist**:
- [ ] Webhook endpoint created
- [ ] Events selected
- [ ] Webhook secret added to env vars
- [ ] Tested webhook (use Stripe CLI for local testing)

---

### 9. Mobile Testing ⚠️ MEDIUM PRIORITY

**Action**:
- Test on iOS Safari
- Test on Android Chrome
- Fix responsive issues
- Test touch gestures

**Checklist**:
- [ ] Tested on iOS
- [ ] Tested on Android
- [ ] Fixed responsive issues
- [ ] Tested touch interactions
- [ ] Tested audio playback

---

### 10. Analytics Setup ⚠️ LOW PRIORITY

**Action**:
- Set up PostHog account
- Add SDK to app
- Track key events
- Set up dashboards

**Checklist**:
- [ ] PostHog account created
- [ ] SDK added to app
- [ ] Events tracked
- [ ] Dashboards created

---

## 🎯 Priority Summary

### **Do First** (Before Launch):
1. ✅ Apply database migrations
2. ✅ Get API keys
3. ✅ Set up environment variables
4. ✅ Deploy RunPod template
5. ✅ Test locally

### **Do Next** (Week 1):
6. ✅ Deploy to Vercel
7. ✅ Set up Stripe webhook
8. ✅ Deploy Edge Function
9. ✅ Mobile testing

### **Do Later** (Week 2+):
10. ✅ Analytics setup
11. ✅ Performance optimization
12. ✅ Advanced features

---

## 📊 Estimated Time

- **Infrastructure Setup**: 2-4 hours
- **Testing**: 2-3 hours
- **Deployment**: 1-2 hours
- **Total**: ~1 day (with API keys ready)

---

## 🆘 Need Help?

- **Migrations**: See `APPLY_MIGRATIONS_GUIDE.md`
- **RunPod**: See `runpod/README.md`
- **Environment**: See `app/.env.local.example`
- **Overview**: See `COMPLETE_OVERVIEW.md`

