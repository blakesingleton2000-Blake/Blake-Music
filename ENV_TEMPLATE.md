# Environment Variables Template

Copy this to `app/.env.local` and fill in your values.

```env
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key

# RunPod Configuration (for MusicGen-large)
RUNPOD_API_KEY=your_runpod_api_key
RUNPOD_ENDPOINT_ID=your_runpod_endpoint_id
RUNPOD_API_URL=https://api.runpod.io/v2

# OpenAI Configuration (for explanations and screenshot OCR)
OPENAI_API_KEY=your_openai_api_key

# Stripe Configuration (for payments)
STRIPE_SECRET_KEY=sk_test_your_stripe_secret_key
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret
NEXT_PUBLIC_STRIPE_PRICE_MONTHLY=price_monthly_subscription_id
NEXT_PUBLIC_STRIPE_PRICE_CREDITS_10=price_credits_10_id

# Spotify OAuth
SPOTIFY_CLIENT_ID=your_spotify_client_id
SPOTIFY_CLIENT_SECRET=your_spotify_client_secret
NEXT_PUBLIC_SPOTIFY_REDIRECT_URI=http://localhost:3000/api/connect/spotify/callback

# Apple Music OAuth
APPLE_MUSIC_TEAM_ID=your_apple_team_id
APPLE_MUSIC_KEY_ID=your_apple_key_id
APPLE_MUSIC_PRIVATE_KEY=your_apple_private_key
NEXT_PUBLIC_APPLE_MUSIC_REDIRECT_URI=http://localhost:3000/api/connect/apple/callback

# App Configuration
NEXT_PUBLIC_APP_URL=http://localhost:3000
NODE_ENV=development

# PostHog Analytics (optional)
NEXT_PUBLIC_POSTHOG_KEY=your_posthog_key
NEXT_PUBLIC_POSTHOG_HOST=https://app.posthog.com
```

## How to Get Each Key

### Supabase
1. Go to https://supabase.com/dashboard
2. Select your project
3. Go to Settings → API → API Keys
4. Copy:
   - **Project URL** → `NEXT_PUBLIC_SUPABASE_URL`
     - Found at: Settings → API → API Settings → Project URL
   - **Publishable key** (new) or **anon key** (legacy) → `NEXT_PUBLIC_SUPABASE_ANON_KEY`
     - Found at: Settings → API → API Keys → Publishable key
     - Note: New keys start with `sb_publishable_`, legacy keys start with `eyJ...`
   - **Secret key** (new) or **service_role key** (legacy) → `SUPABASE_SERVICE_ROLE_KEY`
     - Found at: Settings → API → API Keys → Secret keys → Copy the key
     - Note: New keys start with `sb_secret_`, legacy keys start with `eyJ...`
   - Both new and legacy keys work the same way - use whichever you see in your dashboard

### RunPod
1. Create account at https://www.runpod.io/
2. Deploy serverless template (see `runpod/README.md`)
3. Get:
   - API Key → Settings → API Keys
   - Endpoint ID → Serverless → Endpoints

### OpenAI
1. Go to https://platform.openai.com/api-keys
2. Create new API key
3. Copy key → `OPENAI_API_KEY`

### Stripe
1. Go to https://dashboard.stripe.com/
2. Get API keys:
   - Secret key → `STRIPE_SECRET_KEY`
   - Webhook secret → `STRIPE_WEBHOOK_SECRET` (after creating webhook)
3. Create products:
   - Monthly subscription → Get price ID → `NEXT_PUBLIC_STRIPE_PRICE_MONTHLY`
   - Credits pack → Get price ID → `NEXT_PUBLIC_STRIPE_PRICE_CREDITS_10`

### Spotify OAuth
1. Go to https://developer.spotify.com/dashboard
2. Create app
3. Get:
   - Client ID → `SPOTIFY_CLIENT_ID`
   - Client Secret → `SPOTIFY_CLIENT_SECRET`
4. Add redirect URI: `http://localhost:3000/api/connect/spotify/callback`

### Apple Music OAuth
1. Go to https://developer.apple.com/
2. Create MusicKit key
3. Get:
   - Team ID → `APPLE_MUSIC_TEAM_ID`
   - Key ID → `APPLE_MUSIC_KEY_ID`
   - Private Key → `APPLE_MUSIC_PRIVATE_KEY`

