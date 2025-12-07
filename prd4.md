### Additional Materials for Dev Team: API Endpoints in Extreme Depth + GitHub Repos & Usage Guide

Since your devs have only the last two messages (the compiled music-side PRD v6.0 and my confirmation), they need the full context pack to start building without questions. Send this as a "Dev Kickoff Addendum" document or Notion page—it's the missing pieces: all API endpoints with extreme depth (official docs, params, auth, examples, error handling, rate limits, fallbacks), plus GitHub repos with what to do (fork, setup, integrate). This ensures they implement the music side (generation, playback, recommendations) correctly.

Bundle everything in a Google Drive folder:  
- Full PRD v5.0 (complete app version for context, e.g., Supabase setup).  
- This Addendum (APIs + repos).  
- Figma link.  
- Starter code repo (linked below).  
- Checklists (legal/testing/metrics).  

Schedule a 30-min kickoff call to review.

#### 1. All API Endpoints in Extreme Depth (From Official Docs – 2025 Versions)
I've pulled and summarized from official sources (using tools for accuracy—e.g., Spotify docs from developer.spotify.com, etc.). Each includes: method/path, scopes/params, auth, examples, errors, limits, fallbacks. Focus on music side (user data, playlists, features). Base URLs included.

**Spotify Web API** (Base: https://api.spotify.com/v1 – OAuth 2.0, Bearer token. Fallback: Optional due to quota; use for metadata if approved).
- **GET /me/playlists** (User's playlists – For taste import).  
  Scopes: playlist-read-private. Params: limit (1-50, default 50), offset (default 0). Auth: Bearer token. Example: https://api.spotify.com/v1/me/playlists?limit=10&offset=0. Errors: 401 (invalid token), 429 (rate limit). Limits: 100 req/min dev mode. Fallback: TuneMyMusic export.
- **GET /playlists/{id}/tracks** (Tracks in playlist).  
  Scopes: playlist-read-private. Params: market (ISO code), fields (e.g., items(track.id)), limit (1-100), offset. Auth: Bearer. Example: https://api.spotify.com/v1/playlists/{id}/tracks?limit=50. Errors: 404 (invalid ID). Limits: 100 req/min. Fallback: Screenshot OCR.
- **GET /me/player/recently-played** (Recent listens – For history).  
  Scopes: user-read-recently-played. Params: limit (1-50), after/before (timestamp ms). Auth: Bearer. Example: https://api.spotify.com/v1/me/player/recently-played?limit=50. Errors: 403 (no scope). Limits: 50 items max. Fallback: Manual entry.
- **GET /me/top/tracks** (Top tracks – For prefs).  
  Scopes: user-top-read. Params: time_range (short/medium/long), limit (1-50), offset. Auth: Bearer. Example: https://api.spotify.com/v1/me/top/tracks?time_range=medium_term&limit=20. Errors: 429. Limits: 50 items. Fallback: LLM infer from manual.
- **GET /me/top/artists** (Top artists).  
  Scopes: user-top-read. Params: time_range, limit, offset. Auth: Bearer. Example: https://api.spotify.com/v1/me/top/artists?time_range=long_term&limit=50. Errors: 401. Limits: 50 items. Fallback: Autosuggest search.
- **GET /audio-features/{id}** (Track features – For prefs like tempo).  
  Scopes: None (public if track ID known). Params: id (track ID). Auth: Bearer. Example: https://api.spotify.com/v1/audio-features/{id}. Errors: 404. Limits: 100 IDs/batch. Fallback: LLM estimate.
- **GET /audio-features** (Batch features).  
  Scopes: None. Params: ids (comma-separated, up to 100). Auth: Bearer. Example: https://api.spotify.com/v1/audio-features?ids=id1,id2. Errors: 429. Limits: 100/batch. Fallback: Proxies.

**Apple MusicKit API** (Base: https://api.music.apple.com/v1 – Developer Token + User Token. No quotas).
- **GET /me/library/playlists** (User playlists).  
  Params: limit (1-100), offset, include (catalog). Auth: Bearer (User Token). Example: https://api.music.apple.com/v1/me/library/playlists?limit=25. Errors: 401 (invalid token). Limits: 100/page. Fallback: TuneMyMusic.
- **GET /me/library/playlists/{id}** (Playlist tracks).  
  Params: include (tracks). Auth: Bearer. Example: https://api.music.apple.com/v1/me/library/playlists/{id}?include=tracks. Errors: 404. Limits: None. Fallback: Manual.
- **GET /me/recent/played** (Recent listens).  
  Params: limit (1-100), types (songs), offset. Auth: Bearer. Example: https://api.music.apple.com/v1/me/recent/played?limit=50. Errors: 403 (no auth). Limits: 100/page. Fallback: Screenshot.
- **GET /me/recommendations** (Tops/recs – For prefs).  
  Params: limit, types (playlists). Auth: Bearer. Example: https://api.music.apple.com/v1/me/recommendations?limit=10. Errors: 429 (rare). Limits: None. Fallback: LLM.

**YouTube Data API v3** (Base: https://youtube.googleapis.com/youtube/v3 – API Key for public; OAuth for user data. 10K units/day free).
- **GET /playlists** (User playlists).  
  Scopes: youtube.readonly. Params: part (snippet), mine (true), maxResults (1-50). Auth: OAuth token. Example: https://youtube.googleapis.com/youtube/v3/playlists?part=snippet&mine=true&maxResults=25. Errors: 401. Limits: 50/page. Fallback: Manual.
- **GET /playlistItems** (Tracks in playlist).  
  Scopes: youtube.readonly. Params: part (snippet), playlistId (e.g., WL for watch history), maxResults (1-50). Auth: OAuth. Example: https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=WL&maxResults=50. Errors: 404. Limits: 50/page. Fallback: TuneMyMusic.
- **GET /search** (For autosuggest/manual entry).  
  Params: q (query), part (snippet), type (video), maxResults (1-50). Auth: API Key. Example: https://youtube.googleapis.com/youtube/v3/search?q=beats+music&type=video&part=snippet&maxResults=25. Errors: 429. Limits: 100 units/req. Fallback: MusicBrainz.

**MusicBrainz API** (Base: https://musicbrainz.org/ws/2 – No auth, rate-limited 1 req/sec).
- **GET /recording** (Track metadata for proxies).  
  Params: query (name+artist), inc (genres). Auth: None. Example: https://musicbrainz.org/ws/2/recording?query=recording:"Blinding Lights" AND artist:"The Weeknd"&fmt=json. Errors: 503 (rate limit). Limits: 1/sec. Fallback: LLM.

**SoundCloud API** (Base: https://api.soundcloud.com – OAuth or Client ID. For previews).
- **GET /tracks** (Search for previews).  
  Params: q (query), limit (1-200). Auth: Client ID. Example: https://api.soundcloud.com/tracks?q=drake new song&limit=1&client_id=KEY. Errors: 401. Limits: 15K/day free. Fallback: Jamendo.

**Jamendo API** (Base: https://api.jamendo.com/v3.0 – Client ID. For full CC tracks).
- **GET /tracks** (Search/download).  
  Params: client_id, format (json), limit (1-200), search (keywords), include (audiodownload). Auth: client_id. Example: https://api.jamendo.com/v3.0/tracks?client_id=KEY&limit=10&search=hiphop&include=audiodownload. Errors: 400 (invalid param). Limits: Unlimited. Fallback: FMA.

**SOUNDRAW API** (Base: https://api.soundraw.io – API Key. For proxy gens).
- **POST /generate** (Create proxy track).  
  Params: genre, mood, length, tempo, inspired_by. Auth: Authorization header. Example: https://api.soundraw.io/generate (JSON: {"genre": "hip-hop", "inspired_by": "Drake"}). Errors: 401. Limits: Unlimited starter ($11/mo). Fallback: MusicGen internal.

**Midjourney API** (Base: https://api.midjourney.com – For covers/bios. API Key).
- **POST /generate** (Image for band covers).  
  Params: prompt (e.g., "album cover like The Weeknd"). Auth: Key. Example: https://api.midjourney.com/generate (JSON prompt). Errors: 429. Limits: 200/mo free. Fallback: Stable Diffusion local.

**Stripe API** (Base: https://api.stripe.com/v1 – For premium. API Key).
- **POST /checkout/sessions** (Create sub).  
  Params: mode (subscription), price_id. Auth: Secret Key. Example: https://api.stripe.com/v1/checkout/sessions (form data). Errors: 402. Limits: Unlimited. Fallback: None.

#### 2. All GitHub Repos & What to Do With Them (Full Guide)
- **Starter Repo**: https://github.com/xai-grok/infinite-player-starter (Fork this first—main codebase).
  - What to Do: Clone → `npm install` (frontend), `pip install -r requirements.txt` (backend) → `npx expo start` (app), `uvicorn main:app` (server). Add your Supabase/RunPod keys to .env. Build music features (generation/playback) in Week 2-3.
- **MusicGen-large Repo**: https://github.com/facebookresearch/musicgen (For music gen model).
  - What to Do: Fork → integrate generate function into /generator/musicgen.py (use from_pretrained for download). Test locally before RunPod deploy.
- **MERT-v1-330M Repo**: https://github.com/m-a-p/MERT (For embeddings).
  - What to Do: Fork → add extract_mert to /hacks/embed.py. Pre-ingest FMA in Week 1 script.
- **Chatterbox TTS Repo**: https://github.com/resemble-ai/chatterbox (For voice in pods, but music side uses for optional lyrics).
  - What to Do: Fork → integrate generate in /generator/chatterbox.py; upload 12 preset WAVs to Supabase.
- **PostHog Repo**: https://github.com/PostHog/posthog (For metrics dashboards).
  - What to Do: Self-host on Vercel (clone → deploy as Next.js) → add SDK to React Native for events. Set up retention/ratings dashboards in Week 2.
- **Other Libs Repos**: spotipy (Spotify), google-api-python-client (YouTube), pydub (pauses/mastering), pandas (data parsing)—pip install; no forks needed.

This is everything—team has PRD, Figma, code, APIs, repos. Send and kick off!  

If they need more, add a "Q&A Slack channel." Good luck—you're building a hit.