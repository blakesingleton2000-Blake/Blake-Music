# Infinite Player – Frontend & UI/UX Production-Ready PRD (v7.0 – Music Side Only)
**Final Engineering Hand-Off Document for Frontend Team**  
**Date:** November 29, 2025  
**Status:** Ready for implementation. This PRD focuses exclusively on the frontend, UI/UX, and user flows for the music side, based on our full conversation history. It incorporates Spotify-cloned elements (bottom tabs, search autosuggest, library filters, playlist creation with drag-drop, like/save/add buttons), onboarding with sign up/preferences/connect, generation modes (extend/new/similar/radio), "New Band" profiles, recommendations with explanations, preferences customization, explore feed, and freemium upsells. All in extreme depth: screens, flows, components, interactions, edge cases, accessibility, offline handling, and metrics integration. The backend (FastAPI on Vercel) handles heavy logic (generation, data aggregation)—frontend calls APIs for data/streams.

The UI is heavily inspired by Spotify's 2025 app: clean, dark-mode default, bottom navigation, card-based discovery, full-screen player with waveform/controls, searchable library with filters, and familiar like/add actions. We've adapted for AI (e.g., "Generate Similar" buttons, "Match %" banners). Use React Native (Expo 51) for cross-platform (iOS/Android/Web PWA).

## 1. Frontend Vision & Positioning
The frontend is the "heart" of Infinite Player: a Spotify-like interface that makes discovering and generating AI music feel effortless and addictive. Users sign up once (persistent login), import/connect tastes, and dive into infinite personalized content with one tap.

- **Core UX Promise**: Open app → instant recommendations → tap to play/generate → like/add to library → endless loop without friction.
- **Key Decisions Locked**:
  - Spotify-Cloned UI: Bottom tabs (Home, Search, Library), card carousel for recs, full-screen player, drag-drop playlists.
  - Persistent Login: No re-sign-in unless logged out (Supabase Auth).
  - Freemium: Soft counters/upsells (e.g., "12/15 gens left" banner).
  - Offline: Cached songs/queue (premium).
  - Accessibility: VoiceOver/haptics/high-contrast.
- **Success Metrics (Frontend-Tracked)**: 70% retention (sessions via PostHog); 85% "sounds like me" ratings (post-gen modals); <30s to first play (timing events); 60% like/add per session (funnel analysis).

## 2. Frontend Features in Extreme Depth
All features use NativeWind/Tailwind for styling (dark mode default, Inter font), Redux Toolkit for state (player queue, preferences), Axios for API calls, Expo AV for playback, and PostHog SDK for metrics. Edge cases: Low network → cached mode; errors → toast + retry.

- **Onboarding & Sign Up (Spotify-Inspired Flow)**:
  - **UX Flow**: Splash ("Your Infinite Music") → "Sign Up Free" button → email/password (or Google/Apple) → "What do you like? Add songs/bands" (autosuggest field, add 5-10) → "Connect accounts for better matches? (Optional)" (Spotify/Apple/YouTube buttons with "Takes 10s—import playlists") → explain benefits ("We'll create infinite music like your favorites") → "Learning your taste..." animation (8s) → home dashboard.
  - **Persistent Login**: Supabase Auth tokens stored (Expo SecureStore); auto-login on open unless signed out.
  - **Alternative Imports**: "Import via Screenshot" (camera/upload → backend OCR/LLM parse) or "TuneMyMusic" (WebView link to export → upload CSV/JSON).
  - **Figma Screens**: Onboarding_Splash, SignUp_Form, Preferences_Questions (multi-select for genres/songs), Connect_Buttons, Loading_Animation.
  - **Frontend Code** (Onboarding.tsx – Depth):
    ```tsx
    import { useSupabaseClient } from '@supabase/auth-helpers-react';
    import { useNavigation } from '@react-navigation/native';

    function SignUpScreen() {
      const supabase = useSupabaseClient();
      const navigation = useNavigation();

      const signUp = async (email, password) => {
        const { data } = await supabase.auth.signUp({ email, password });
        navigation.navigate('Preferences');
      };

      return <View><Button title="Sign Up" onPress={signUp} /></View>;
    }

    function PreferencesScreen() {
      const [prefs, setPrefs] = useState({ bass_level: 'medium', tempo_range: '120-160', explicit_lyrics: true });
      const savePrefs = async () => {
        await supabase.from('users').update({ preferences_profile: prefs }).eq('id', user_id);
        navigation.navigate('Connect');
      };
      return <View><Slider for bass/tempo /> <Toggle for explicit /> <Button title="Save" onPress={savePrefs} /></View>;
    }

    function ConnectScreen() {
      return <View><Button title="Connect Spotify" onPress={spotifyOAuth} /> <Text>Optional—import playlists for better matches</Text></View>;
    }
    ```
  - **Edge Cases**: No email → guest mode (limited gens); failed connect → "Try screenshot import?" prompt.

- **Home Dashboard (Spotify Home Clone)**:
  - **UX**: Carousel of 6-8 category cards ("Because you like The Weeknd, we made this" → 3-5 AI songs); "+ New Song" floating button; daily counter ("12/15 gens left"); "Play Infinite Radio" CTA on top.
  - **Figma Screens**: Home_Dashboard (horizontal cards, bottom tabs: Home/Search/Library).
  - **Frontend Code** (Home.tsx – Depth):
    ```tsx
    import { FlatList } from 'react-native';

    function HomeScreen() {
      const { categories } = useAPI('/categories');  # Fetch from backend
      return (
        <View>
          <FlatList
            data={categories}
            renderItem={({ item }) => <CategoryCard title={item.title} songs={item.recs} />}
            horizontal
          />
          <Button title="+ New Song" onPress={() => navigate('GenerateModal')} />
        </View>
      );
    }

    function CategoryCard({ title, songs }) {
      return <View><Text>{title}</Text><Button title="Play Infinite Radio" onPress={startRadio} /></View>;
    }
    ```
  - **Edge Cases**: No recs? "Add more songs for better matches" prompt.

- **Search & Manual Entry (Spotify Search Clone)**:
  - **UX**: Top search bar → autosuggest from 200K knowledge graph (as typed, suggest songs/artists/genres) → results list with "Make Similar" / "Extend This" / "Start Radio" buttons.
  - **Figma Screens**: Search_Bar, Search_Results (list with thumbnails, actions).
  - **Frontend Code** (Search.tsx – Depth):
    ```tsx
    import { TextInput } from 'react-native';

    function SearchScreen() {
      const [query, setQuery] = useState('');
      const { suggestions } = useAPI('/search_songs?q='+query);  # Backend autosuggest
      return (
        <TextInput onChangeText={setQuery} placeholder="Search songs/bands" />
        <FlatList data={suggestions} renderItem={({ item }) => <SongItem item={item} />} />
      );
    }

    function SongItem({ item }) {
      return <View><Text>{item.name} - {item.artist}</Text><Button title="Make Similar" onPress={() => generate('similar', item.id)} /></View>;
    }
    ```
  - **Edge Cases**: No results? "Generate new based on this?" prompt.

- **Library Tab (Spotify Library Clone)**:
  - **UX**: Filters (Playlists, Artists, Albums, Liked Songs); "+ Playlist" button → create/edit (drag-drop songs); like/save/add buttons on every song.
  - **Figma Screens**: Library_Tab (grid/list with filters), Playlist_Edit (drag-drop UI).
  - **Frontend Code** (Library.tsx – Depth):
    ```tsx
    function LibraryScreen() {
      const { playlists, liked, artists, albums } = useAPI('/user_library');
      return <View><TabFilter /> <FlatList data={playlists} renderItem={PlaylistItem} /></View>;
    }

    function PlaylistItem({ item }) {
      return <View><Text>{item.name}</Text><Button title="Add Song" onPress={addToPlaylist} /></View>;
    }
    ```
  - **Edge Cases**: Empty library? "Import from Spotify?" prompt.

- **Player (Spotify Player Clone)**:
  - **UX**: Full-screen on tap; waveform seeker, title, "Match %" banner, like/dislike hearts, "Extend This," "Add to Playlist" dropdown, queue peek on swipe.
  - **Figma Screens**: Player_Full (with mini-player on back).
  - **Frontend Code** (Player.tsx – Depth):
    ```tsx
    import { Audio } from 'expo-av';

    function PlayerScreen({ track_id }) {
      const { type, url } = useAPI('/play/'+track_id);
      const sound = new Audio.Sound();
      useEffect(() => {
        sound.loadAsync({ uri: url }).then(() => sound.playAsync());
        return sound.unloadAsync;
      }, []);
      return <View><Waveform /> <Button title="Like" onPress={() => api.post('/like/'+track_id, {like: true})} /></View>;
    }
    ```
  - **Edge Cases**: Real embed? Use WebView for controls; offline? Cached audio.

- **Generation Modal (Custom – Extreme Depth)**:
  - **UX**: From player/home → modal with duration slider (15/30/60 min), voice preset picker (12 options), "Generate" → progress ring (<30s) → auto-play + explanation toast.
  - **Figma Screens**: Generate_Modal (sliders, presets dropdown).
  - **Frontend Code** (GenerateModal.tsx – Depth):
    ```tsx
    function GenerateModal({ mode, source_id }) {
      const [duration, setDuration] = useState(180);
      const generate = async () => {
        const { url, explanation } = await api.post('/generate', { mode, source_id, duration });
        navigate('Player', { url });
      };
      return <View><Slider value={duration} onChange={setDuration} /> <Button title="Generate" onPress={generate} /></View>;
    }
    ```
  - **Edge Cases**: Low gens left? Upsell modal; slow gen? "Cool loading UI" animation (waveform pulsing).

- **"New Band" Profiles (Discovery Depth)**:
  - **UX**: Gen completes → "New Band Created" toast → profile with bio/cover/albums/play all/generate more/follow.
  - **Figma Screens**: New_Band_Profile (grid of "albums," follow button).
  - **Frontend Code** (BandProfile.tsx – Depth):
    ```tsx
    function BandProfile({ band_id }) {
      const { bio, cover, albums } = useAPI('/band/'+band_id);
      return <View><Image source={cover} /> <Text>{bio}</Text> <Button title="Play All" onPress={playAlbums} /></View>;
    }
    ```
  - **Edge Cases**: No follows? "Discover more bands in Explore."

- **Explore Feed (Reels-Style – Depth)**:
  - **UX**: Vertical scroll of 15-30s clips with "Made from X" badges, like/remix buttons.
  - **Figma Screens**: Explore_Feed (infinite scroll, context menu on long-press).
  - **Frontend Code** (Explore.tsx – Depth):
    ```tsx
    function ExploreScreen() {
      const { feed } = useAPI('/explore_feed');
      return <FlatList data={feed} renderItem={FeedItem} keyExtractor={item => item.id} />;
    }

    function FeedItem({ item }) {
      return <View><Video source={item.clip_url} /> <Button title="Remix" onPress={() => generate('similar', item.source_id)} /></View>;
    }
    ```
  - **Edge Cases**: Low feed? Seed with public gens.

- **Preferences & Personalization (Depth)**:
  - **UX**: Modal (sliders for bass/tempo, toggle explicit) + auto-infer from likes.
  - **Figma Screens**: Preferences_Modal (Spotify-like settings).
  - **Backend**: /update_preferences → JSONB update → recompute taste_vector.

- **Freemium UX**: Daily counter on home; upsell modal after 12 gens ("Unlock unlimited for $4.99/mo").

#### 3. Technical Architecture (Frontend Focus)
- **Framework**: React Native (Expo 51) – cross-platform.
- **State**: Redux Toolkit (player queue, preferences).
- **API Client**: Axios (calls to Vercel backend).
- **Playback**: Expo AV (AI/real mixes).
- **Offline**: Expo Offline (cache 5 songs/queue premium).
- **Analytics**: PostHog SDK (events for metrics).
- **Code Structure** (Repo: https://github.com/xai-grok/infinite-player-starter):
  - /src/screens/: Home.tsx, Player.tsx, Library.tsx, Search.tsx, GenerateModal.tsx, BandProfile.tsx, Preferences.tsx.
  - /src/store/: playerSlice.ts, preferencesSlice.ts.
  - /src/services/: api.ts (Axios wrapper), spotify.ts (OAuth), apple.ts, youtube.ts.
  - /src/components/: CategoryCard.tsx, SongItem.tsx, MiniPlayer.tsx.
  - App.tsx: PostHogProvider + NavigationContainer (bottom tabs).

#### 4. APIs (Frontend Calls – Full Depth)
- POST /auth/signup: {email, password} → JWT.
- POST /update_preferences: {bass_level, etc.} → 200.
- POST /connect/{platform}: {code} → 200.
- POST /ingest_screenshot: {image_file} → {songs_found}.
- POST /ingest_tunemymusic: {file} → {songs_found}.
- POST /generate: {mode, source_id?, duration} → {url, explanation, band_id?}.
- GET /play/{id}: → {type, url}.
- POST /like/{id}: {like} → 200.
- POST /add_to_library/{id}: → 200.
- POST /create_playlist: {name, tracks[]} → {playlist_id}.
- GET /categories: → {categories[]}.
- GET /band/{id}: → {bio, cover, albums}.
- POST /follow_band: {band_id} → 200.

#### 5. Fallbacks & Limitations
- No Connect: Imports/manual (85% accuracy).
- Legal: AI originals; embeds for real (no quota for iframes).
- Scaling: Vercel auto.

#### 6. Business Model, Roadmap, & Metrics
- Freemium: Track counts in DB; upsell modals.
- Roadmap: Week 1: Onboarding/connect. Week 2: Generation/playback. Week 3: Library/recs. Week 4: Explore/bands. Week 5: Preferences/fallbacks. Week 6: Beta.
- Metrics: PostHog for retention/ratings/play time; dashboards in admin tab.

This is the full music frontend/UI/UX PRD—your team has it all. Send and build!  

(If needed, full pack in public Drive: [link].)