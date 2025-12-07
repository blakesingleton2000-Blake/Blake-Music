# Environment Variables Setup

## Required for Basic Functionality

These are already set in `.env.local`:

```env
NEXT_PUBLIC_SUPABASE_URL=https://djszkpgtwhdjhexnjdof.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=sb_publishable_cK8kjrpekz2ssEwQOBvbtw_yxM37UGQ
SUPABASE_SERVICE_ROLE_KEY=sb_secret_Nfa9TqrXPq6v-nKqb19nFg_B3FukR8X
```

## Required for Music Generation (RunPod)

Get these from https://www.runpod.io/:

```env
RUNPOD_API_KEY=your_runpod_api_key
RUNPOD_ENDPOINT_ID=your_endpoint_id
RUNPOD_API_URL=https://api.runpod.io/v2  # Optional, defaults to this
```

**Steps to get RunPod credentials:**
1. Sign up at https://www.runpod.io/
2. Deploy MusicGen-large model (A100 GPU)
3. Get API key from account settings
4. Get endpoint ID from your deployment

## Required for OAuth Connections

### Spotify OAuth

Get from https://developer.spotify.com/dashboard:

```env
SPOTIFY_CLIENT_ID=your_spotify_client_id
SPOTIFY_CLIENT_SECRET=your_spotify_client_secret
```

**Steps:**
1. Go to Spotify Developer Dashboard
2. Create a new app
3. Add redirect URI: `http://localhost:3000/api/connect/spotify/callback` (dev)
4. Add redirect URI: `https://your-domain.com/api/connect/spotify/callback` (prod)
5. Copy Client ID and Client Secret

### Apple Music OAuth

Get from https://developer.apple.com/account/resources/identifiers/list:

```env
APPLE_MUSIC_KEY_ID=your_key_id
APPLE_MUSIC_TEAM_ID=your_team_id
APPLE_MUSIC_PRIVATE_KEY=your_private_key_content
```

**Steps:**
1. Go to Apple Developer Account
2. Create MusicKit Key
3. Download .p8 private key file
4. Copy Key ID and Team ID
5. Add private key content (or path to file)

## Optional (For Future Features)

### OpenAI (for LLM explanations, band bios)

```env
OPENAI_API_KEY=sk-your-openai-key
```

### Stripe (for payments)

```env
STRIPE_SECRET_KEY=sk_test_your_key
STRIPE_PUBLISHABLE_KEY=pk_test_your_key
STRIPE_MODE=test  # or 'live' for production
```

### PostHog (for analytics)

```env
NEXT_PUBLIC_POSTHOG_KEY=your_key
NEXT_PUBLIC_POSTHOG_HOST=https://your-instance.com
```

---

## Adding to Vercel

1. Go to your Vercel project → **Settings** → **Environment Variables**
2. Add each variable for **Production**, **Preview**, and **Development**
3. Redeploy after adding new variables

---

## Testing Locally

1. Copy `.env.example` to `.env.local`
2. Fill in your actual values
3. Restart dev server: `npm run dev`

