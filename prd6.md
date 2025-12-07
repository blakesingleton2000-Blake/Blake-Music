### Infinite Player – Music Module: Complete Specs & Features (Compiled from Full Thread)
**PRD v6.0 – Music Side Only**  
**Date:** November 29, 2025  
**Overview**: This is the exhaustive compilation of all music-related specs, features, UX/UI, technical architecture, APIs, databases, fallbacks, and business elements discussed throughout our conversation. It excludes podcasts/explainers (the "Pods & Explains" side) to focus solely on music generation, playback, recommendations, and personalization. The system is designed to deliver unlimited, 100% original AI-generated songs tailored to user taste, with seamless UX that feels like a "personal Spotify but infinite." All grounded in 2025 tech realities—no blocked APIs, scalable to 10K+ DAU at <$1,300/mo.

The UI is heavily inspired by Spotify's interface (as per your request to "clone Spotify’s UI for a lot of this"), based on Spotify's 2025 app overview: clean navigation with bottom tabs (Home, Search, Library), card-based home screen for recommendations, full-screen player with waveform and controls, playlist creation with drag-drop, library view with filters (playlists, artists, albums, liked songs), search with autosuggest, and like/save/add buttons on every track. We've adapted it for AI features (e.g., "Generate Similar" button in player), keeping it familiar for users transitioning from Spotify.

#### 1. Music Vision & Positioning
- **Core Promise**: Turn any user's music taste (from playlists, songs, or history) into infinite original songs, extensions, and playlists that sound exactly like their favorites—generated on-demand with one tap.
- **Key Features Summary**:
  - Onboarding: Sign up with email (persistent login unless signed out), ask preferences (music, songs, bands), connect accounts (Spotify/Apple/YouTube), explain benefits ("Connect to import your playlists and get personalized AI music").
  - Generation: Extend song, new song, similar to one, similar playlist (infinite radio).
  - Discovery: Explore feed (Reels-style community gens), "New Band" profiles for AI creations.
  - Playback: Unified player for AI + real music (embeds for real tracks).
  - Recommendations: "Because you like X, we made Y" categories, powered by taste vector.
  - Interactions: Like songs, add to library, save songs, create playlists (just like Spotify—drag-drop, edit, share).
  - Preferences: DB tracking bass, tempo, explicit lyrics, etc., for hyper-personalized gens.
- **Differentiation**: No repeats; AI as "new bands" with bios/covers; multi-platform without quota walls.
- **Target Users**: Music enthusiasts (18-35) frustrated with repetition; power users seeking discovery.
- **Success Metrics**: 70% retention after 10 sessions; 85% "sounds like me" ratings; <30s to first play; 60% like/add per session.

#### 2. Music Features in Extreme Depth
All features support offline caching (premium) and accessibility (VoiceOver/haptics).

- **Onboarding & Data Import (To Understand Taste)**:
  - **Sign Up Flow** (Spotify-Inspired): "Sign Up Free" button → email/password (or Google/Apple login) → "What do you like? Search songs/bands" (autosuggest field, add 5-10 to start taste_vector) → "Connect accounts to import playlists" (optional Spotify/Apple/YouTube buttons, explain "For better matches—takes 10s") → "Learning your taste..." (8s animation) → home dashboard.
  - **Persistent Login**: Supabase Auth remembers unless signed out; auto-login on open.
  - **Alternative Imports**: Screenshot (OCR + LLM extracts songs/artists/plays); manual entry (autosuggest search from 200K knowledge graph); TuneMyMusic export (full playlists/liked songs as CSV/JSON, one-time).
  - **UX**: Spotify-like clean form; "Skip to demo" for quick start (seed from charts).
  - **Backend**: /ingest_tunemymusic endpoint parses CSV → resolves embeddings → computes initial taste_vector.
  - **Continuous Update**: Poll connected apps daily (edge function) → append to user_history.
  - **Fallbacks**: No connect? Seed from global charts + FMA proxies (80% accuracy).

- **Song Generation Modes (Core Loop)**:
  - **Extend Current Song**: Tap "Extend to 15/30/60 min" → uses source embedding → chunked MusicGen with re-injection for coherence.
  - **New Song**: "+ New Song" button → uses taste_vector + preferences (e.g., "high bass, explicit").
  - **Similar to One Song**: Long-press song → "Make Similar" → 70% source embedding + 30% user vector.
  - **Similar Playlist (Infinite Radio)**: "Play Infinite Radio" → average playlist embeddings → endless queue (auto-gens next on skip, no gen on skip to avoid delays—use pre-gen cache or loading UI spinner if needed).
  - **UX**: Modal for duration/voice preset; progress ring (<30s) → auto-play with "Match 92%" banner + explanation. Cool loading UI for V2: Animated waveform "Generating..." with cancel.
  - **Backend**: /generate endpoint (modes as param) → resolves conditioning → MusicGen + mastering → Supabase URL.
  - **Preferences Integration**: DB tracks "bass_level", "tempo_range", "explicit_lyrics" → adds to prompt.

- **Discovery & "New Band" Concept**:
  - **Explore Feed**: Reels-style vertical scroll of community gens (15-30s clips) with "Made from The Weeknd – Blinding Lights" badge.
  - **New Band Profiles**: Each AI gen groups into "bands" (e.g., "AI Weeknd Vibe") with auto-bio/cover (Llama/Midjourney) + "albums" (gens).
  - **UX**: Tap band card → profile with "Play All," "Generate More," "Follow" (pushes new gens).
  - **Backend**: /generate adds {create_band: bool} → saves to bands table.

- **Recommendations ("Because You Like X, We Made Y")**:
  - **Logic**: pgvector query on taste_vector for similars → gen 3-5 AI songs → group into categories.
  - **UX**: Home carousel (6-8 cards) – tap → queue with explanations.
  - **Backend**: /categories endpoint → aggregate_and_recommend function.

- **Playback & Listening**:
  - **Unified Player**: For AI (Supabase MP3s) + real (embeds from Apple/YouTube; no quota needed for iframes).
  - **UX**: Tap song → full-screen player (<2s load) with waveform, like/add, "Extend This," queue peek. Mixes AI + real (e.g., AI rec + imported song).
  - **Backend**: /play/{id} → returns {type: 'ai'|'real', url} (embeds for real).

- **Spotify-Like Interactions**:
  - **Like/Dislike**: Hearts in player → refines taste_vector.
  - **Add to Library/Save Songs**: "Add to Favorites" button → saves to user_library table.
  - **Create Playlists**: "+ Playlist" button → drag-drop songs (real/AI); edit/share like Spotify.
  - **UX**: Library tab with filters (Playlists, Artists, Albums, Liked Songs); search with autosuggest.
  - **Backend**: /add_to_library, /create_playlist endpoints.

- **Preferences DB (For "We Know What They'll Like")**:
  - **Data**: "bass_level" (high/low), "tempo_range" (120-160), "explicit_lyrics" (true/false), from history/feedback.
  - **UX**: Preferences modal (sliders/toggles) + auto-infer from likes.
  - **Backend**: update_preferences job (daily/from feedback) → JSONB in users table.

#### 3. Technical Architecture (Music Side)
- **Backend**: FastAPI on Vercel (serverless).
- **DB**: Supabase Postgres + pgvector (taste_vector, embeddings).
- **Generation**: MusicGen-large on RunPod A100 (chunked for extensions).
- **Embeddings**: MERT-v1-330M; proxies from FMA/Jamendo/SoundCloud/SOUNDRAW.
- **APIs**: Apple MusicKit/YouTube Data (primary); Spotify optional; TuneMyMusic for imports.
- **Code** (generate.py – Full Depth):
  ```python
  def generate(user_id, mode, source_id=None, duration=180):
      profile = get_preferences(user_id)
      prompt = f"Generate with {profile['bass_level']} bass, tempo {profile['tempo_range']}, { 'explicit lyrics' if profile['explicit_lyrics'] else 'clean lyrics' }"
      conditioning = get_conditioning(user_id, mode, source_id, prompt)
      audio = musicgen.generate(conditioning, duration)
      mastered = mastering_chain(audio)
      url = upload_supabase(mastered)
      explanation = llm_explain(mode, source_id)
      save_track(user_id, url, mode, explanation)
      return {"url": url, "explanation": explanation}
  ```

#### 4. Fallbacks & Limitations
- **No Quota/Connect**: Screenshot/manual/TuneMyMusic imports (85% accuracy).
- **Legal**: 100% original AI; embeds for real (no storage).
- **Scaling**: Vercel auto; RunPod autoscaling.

#### 5. Business Model (Music Side)
- Freemium: Free 15 gens/day; $4.99/mo unlimited + commercial rights.
- B2B: License engine ($10K/mo clients).
- IAP: Credits for extra gens ($0.99/10).

#### 6. Roadmap & Metrics
- Week 1-6: MVP build.
- Metrics: Retention 70%; ratings 85%; adds <30s to first play.

This is the full music side—your team has it all. Send and build!  

(If needed, full PRD PDF in public Google Drive: [link].)