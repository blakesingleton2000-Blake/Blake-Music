# API Keys Explained - What You Need & Why

## 🔴 Critical (App Won't Work Without These)

### 1. **Supabase Keys** (REQUIRED)
**Why**: Your entire database and authentication system

- `NEXT_PUBLIC_SUPABASE_URL`
  - **What**: Your Supabase project URL
  - **Used for**: Connecting to database, auth, storage
  - **Get from**: Supabase Dashboard → Settings → API → Project URL
  - **Without it**: App crashes on startup

- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
  - **What**: Public/anonymous key for client-side operations
  - **Used for**: User authentication, reading public data
  - **Get from**: Supabase Dashboard → Settings → API → anon/public key
  - **Without it**: Can't sign up, log in, or access database

- `SUPABASE_SERVICE_ROLE_KEY`
  - **What**: Admin key (server-side only!)
  - **Used for**: Admin operations, bypassing RLS, uploading files
  - **Get from**: Supabase Dashboard → Settings → API → service_role key
  - **Without it**: Can't upload audio, can't do admin operations

**Cost**: Free tier available

---

### 2. **RunPod Keys** (REQUIRED)
**Why**: Music generation won't work without GPU endpoint

- `RUNPOD_API_KEY`
  - **What**: API key to authenticate with RunPod
  - **Used for**: Calling MusicGen GPU endpoint
  - **Get from**: RunPod Dashboard → Settings → API Keys
  - **Without it**: Music generation fails completely

- `RUNPOD_ENDPOINT_ID`
  - **What**: Your specific GPU endpoint ID
  - **Used for**: Which GPU endpoint to use
  - **Get from**: RunPod Dashboard → Serverless → Endpoints → Copy ID
  - **Without it**: Don't know which endpoint to call

**Cost**: ~$0.01 per generation (A100 Spot)

---

## 🟡 Important (Core Features Won't Work)

### 3. **OpenAI Key** (IMPORTANT)
**Why**: Used for explanations and screenshot OCR

- `OPENAI_API_KEY`
  - **What**: OpenAI API key
  - **Used for**:
    - Generating "Because you like X..." explanations
    - Parsing screenshots (Vision API)
    - Band name/bio generation
  - **Get from**: https://platform.openai.com/api-keys
  - **Without it**:
    - Explanations will be generic placeholders
    - Screenshot import won't work
    - Band names will be generic

**Cost**: ~$0.01-0.10 per generation (GPT-4)

---

### 4. **Stripe Keys** (IMPORTANT)
**Why**: Premium subscriptions and payments

- `STRIPE_SECRET_KEY`
  - **What**: Server-side Stripe secret key
  - **Used for**: Creating checkout sessions, processing payments
  - **Get from**: Stripe Dashboard → Developers → API Keys → Secret key
  - **Without it**: Premium upgrade won't work

- `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY`
  - **What**: Public Stripe key (safe to expose)
  - **Used for**: Stripe checkout UI
  - **Get from**: Stripe Dashboard → Developers → API Keys → Publishable key
  - **Without it**: Checkout page won't load

- `STRIPE_WEBHOOK_SECRET`
  - **What**: Webhook secret to verify Stripe events
  - **Used for**: Verifying payment webhooks are from Stripe
  - **Get from**: Stripe Dashboard → Developers → Webhooks → Add endpoint → Copy secret
  - **Without it**: Payment confirmations won't work reliably

- `NEXT_PUBLIC_STRIPE_PRICE_MONTHLY`
  - **What**: Price ID for monthly subscription
  - **Used for**: Monthly premium subscription
  - **Get from**: Stripe Dashboard → Products → Create → Copy Price ID
  - **Without it**: Can't create monthly subscription

- `NEXT_PUBLIC_STRIPE_PRICE_CREDITS_10`
  - **What**: Price ID for credits pack
  - **Used for**: One-time credit purchases
  - **Get from**: Stripe Dashboard → Products → Create → Copy Price ID
  - **Without it**: Can't sell credit packs

**Cost**: 2.9% + $0.30 per transaction (Stripe fees)

---

## 🟢 Optional (Features Won't Work, But App Still Functions)

### 5. **Spotify OAuth** (OPTIONAL)
**Why**: Import user's Spotify playlists and history

- `SPOTIFY_CLIENT_ID`
  - **What**: Spotify app client ID
  - **Used for**: OAuth flow initiation
  - **Get from**: https://developer.spotify.com/dashboard → Create App → Client ID
  - **Without it**: "Connect Spotify" button won't work

- `SPOTIFY_CLIENT_SECRET`
  - **What**: Spotify app secret
  - **Used for**: Exchanging OAuth code for access token
  - **Get from**: Spotify Dashboard → App Settings → Client Secret
  - **Without it**: Can't complete OAuth flow

**Cost**: Free (but has quota limits)

---

### 6. **Apple Music OAuth** (OPTIONAL)
**Why**: Import user's Apple Music playlists and history

- `APPLE_MUSIC_TEAM_ID`
  - **What**: Apple Developer Team ID
  - **Used for**: JWT token generation
  - **Get from**: Apple Developer Account → Membership → Team ID
  - **Without it**: Apple Music OAuth won't work

- `APPLE_MUSIC_KEY_ID`
  - **What**: MusicKit Key ID
  - **Used for**: JWT token generation
  - **Get from**: Apple Developer → Certificates, Identifiers & Profiles → Keys → Create MusicKit Key → Copy Key ID
  - **Without it**: Can't generate Apple Music tokens

- `APPLE_MUSIC_PRIVATE_KEY`
  - **What**: MusicKit private key (.p8 file content)
  - **Used for**: Signing JWT tokens
  - **Get from**: Download .p8 file when creating MusicKit key → Copy contents
  - **Without it**: Can't authenticate with Apple Music API

**Cost**: $99/year (Apple Developer Program)

---

### 7. **PostHog Analytics** (OPTIONAL)
**Why**: Track user behavior and retention

- `NEXT_PUBLIC_POSTHOG_KEY`
  - **What**: PostHog project API key
  - **Used for**: Event tracking
  - **Get from**: PostHog Dashboard → Project Settings → API Key
  - **Without it**: No analytics tracking

- `NEXT_PUBLIC_POSTHOG_HOST`
  - **What**: PostHog instance URL
  - **Used for**: Where to send analytics events
  - **Get from**: Usually `https://app.posthog.com` (cloud) or your self-hosted URL
  - **Without it**: Analytics won't work

**Cost**: Free tier available (cloud) or self-hosted (free)

---

## 📋 Summary: What You MUST Have

### Minimum to Launch (Core Features):
1. ✅ Supabase (3 keys) - Database & Auth
2. ✅ RunPod (2 keys) - Music Generation

### Recommended for Full Features:
3. ✅ OpenAI (1 key) - Explanations & Screenshot OCR
4. ✅ Stripe (5 keys) - Payments & Premium

### Nice to Have:
5. ⚪ Spotify (2 keys) - Playlist Import
6. ⚪ Apple Music (3 keys) - Playlist Import
7. ⚪ PostHog (2 keys) - Analytics

---

## 💰 Cost Breakdown

| Service | Cost | Required? |
|---------|------|-----------|
| Supabase | Free tier | ✅ Yes |
| RunPod | ~$0.01/gen | ✅ Yes |
| OpenAI | ~$0.01-0.10/gen | 🟡 Recommended |
| Stripe | 2.9% + $0.30 | 🟡 Recommended |
| Spotify | Free | ⚪ Optional |
| Apple Music | $99/year | ⚪ Optional |
| PostHog | Free tier | ⚪ Optional |

**Total Monthly Cost (1000 users, 10k generations)**:
- Supabase: $0 (free tier)
- RunPod: ~$100
- OpenAI: ~$10-100
- Stripe: 2.9% of revenue
- **Total**: ~$110-200/month + Stripe fees

---

## 🚀 Quick Setup Priority

### Phase 1: Get App Running (30 min)
1. Supabase keys (get from dashboard)
2. RunPod keys (after deploying endpoint)

### Phase 2: Add Core Features (1 hour)
3. OpenAI key (for explanations)
4. Stripe keys (for payments)

### Phase 3: Add Import Features (Optional)
5. Spotify keys (if you want Spotify import)
6. Apple Music keys (if you want Apple Music import)

### Phase 4: Add Analytics (Optional)
7. PostHog keys (if you want analytics)

---

## 🔐 Security Notes

- **Never commit** `.env.local` to git (already in `.gitignore`)
- **Service role keys** should NEVER be exposed to client
- **Public keys** (NEXT_PUBLIC_*) are safe to expose in browser
- **Rotate keys** if exposed or compromised
- **Use different keys** for development vs production

---

## 📝 Where to Get Each Key

See `ENV_TEMPLATE.md` for detailed instructions on getting each key.

---

**TL;DR**: You need **Supabase + RunPod** minimum. Add **OpenAI + Stripe** for full features. Everything else is optional.


