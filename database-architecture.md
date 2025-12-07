# Infinite Player - Database Architecture

**Project**: Music (Supabase)  
**Project URL**: https://djszkpgtwhdjhexnjdof.supabase.co  
**Last Updated**: January 2025

---

## Overview

This database schema supports the Infinite Player MVP: AI music generation, user preferences, taste vectors, playlists, bands, and freemium tracking. Uses PostgreSQL with pgvector extension for similarity search.

---

## Schema Design Principles

1. **User-centric**: All data tied to `users.id` (UUID)
2. **Vector search**: pgvector for taste similarity and recommendations
3. **JSONB flexibility**: Preferences, playlists stored as JSONB for flexibility
4. **Audit trails**: `created_at`, `updated_at` timestamps on all tables
5. **Row Level Security**: RLS enabled on all tables for multi-tenant security

---

## Tables

### 1. `users`

Core user account and preferences.

| Column | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `id` | `uuid` | PRIMARY KEY, DEFAULT `gen_random_uuid()` | User ID |
| `email` | `text` | UNIQUE, NOT NULL | Email address |
| `taste_vector` | `vector(768)` | NULL | MERT embedding (768-dim) |
| `preferences_profile` | `jsonb` | DEFAULT `'{}'::jsonb` | User preferences (genres, artists, bass, tempo, etc.) |
| `daily_count` | `integer` | DEFAULT `0` | Daily generation counter (resets at midnight UTC) |
| `premium` | `boolean` | DEFAULT `false` | Premium subscription status |
| `onboarding_completed` | `boolean` | DEFAULT `false` | Onboarding flow completion |
| `created_at` | `timestamptz` | DEFAULT `now()` | Account creation time |
| `updated_at` | `timestamptz` | DEFAULT `now()` | Last update time |

**Indexes**:
- `idx_users_email` on `email`
- `idx_users_taste_vector` using `ivfflat` (pgvector) for similarity search

**RLS Policies**:
- Users can read/update their own row
- Service role can read/update all rows

**Example `preferences_profile` JSON**:
```json
{
  "genres": ["pop", "hip-hop", "electronic"],
  "favorite_artists": ["The Weeknd", "Drake", "Dua Lipa"],
  "vibe": "energetic",
  "bass_level": "high",
  "tempo_range": "120-160",
  "explicit_lyrics": true,
  "onboarding_date": "2025-01-15T10:30:00Z"
}
```

---

### 2. `user_history`

Tracks user's listening history from OAuth imports and app usage.

| Column | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `id` | `uuid` | PRIMARY KEY, DEFAULT `gen_random_uuid()` | History entry ID |
| `user_id` | `uuid` | FOREIGN KEY → `users.id`, NOT NULL | User who played this |
| `platform` | `text` | NOT NULL | Source: `spotify`, `apple`, `youtube`, `infinite` |
| `track_id` | `text` | NULL | External track ID (Spotify URI, etc.) |
| `track_name` | `text` | NOT NULL | Track name |
| `artist` | `text` | NOT NULL | Artist name |
| `album` | `text` | NULL | Album name |
| `played_at` | `timestamptz` | DEFAULT `now()` | When track was played |
| `play_count` | `integer` | DEFAULT `1` | Number of times played |

**Indexes**:
- `idx_user_history_user_id` on `user_id`
- `idx_user_history_played_at` on `played_at DESC`
- `idx_user_history_user_played` on `(user_id, played_at DESC)`

**RLS Policies**:
- Users can read/insert their own history
- Service role can read/insert all

---

### 3. `embeddings`

Cached music embeddings from MusicBrainz and other sources.

| Column | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `id` | `uuid` | PRIMARY KEY, DEFAULT `gen_random_uuid()` | Embedding ID |
| `track_id` | `text` | UNIQUE, NULL | External track ID (MusicBrainz, Spotify, etc.) |
| `track_name` | `text` | NOT NULL | Track name |
| `artist` | `text` | NOT NULL | Artist name |
| `vector` | `vector(768)` | NOT NULL | MERT embedding (768-dim) |
| `genre` | `text[]` | DEFAULT `'{}'` | Genre tags |
| `source` | `text` | NOT NULL | Source: `musicbrainz`, `spotify`, `fma`, `jamendo` |
| `created_at` | `timestamptz` | DEFAULT `now()` | When embedding was created |

**Indexes**:
- `idx_embeddings_track_id` on `track_id`
- `idx_embeddings_vector` using `ivfflat` (pgvector) for similarity search
- `idx_embeddings_artist` on `artist`

**RLS Policies**:
- Public read access (embeddings are shared)
- Service role can insert/update

---

### 4. `generated_tracks`

AI-generated music tracks.

| Column | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `id` | `uuid` | PRIMARY KEY, DEFAULT `gen_random_uuid()` | Track ID |
| `user_id` | `uuid` | FOREIGN KEY → `users.id`, NOT NULL | Creator user |
| `url` | `text` | NOT NULL | Supabase Storage URL (MP3) |
| `duration` | `integer` | NOT NULL | Duration in seconds |
| `mode` | `text` | NOT NULL | Generation mode: `new`, `similar`, `extend`, `radio` |
| `source_id` | `uuid` | FOREIGN KEY → `generated_tracks.id`, NULL | Source track (for similar/extend) |
| `source_external_id` | `text` | NULL | External source (Spotify URI, etc.) |
| `explanation` | `text` | NULL | LLM explanation ("Because you like...") |
| `match_percentage` | `integer` | NULL | Match score (0-100) |
| `status` | `text` | DEFAULT `'completed'` | Status: `queued`, `generating`, `completed`, `failed` |
| `band_id` | `uuid` | FOREIGN KEY → `bands.id`, NULL | Associated band |
| `created_at` | `timestamptz` | DEFAULT `now()` | Generation time |

**Indexes**:
- `idx_generated_tracks_user_id` on `user_id`
- `idx_generated_tracks_created_at` on `created_at DESC`
- `idx_generated_tracks_band_id` on `band_id`
- `idx_generated_tracks_status` on `status`

**RLS Policies**:
- Users can read their own tracks + public tracks
- Users can insert/update their own tracks
- Service role can read/insert/update all

---

### 5. `bands`

AI-generated "bands" (grouped tracks with style).

| Column | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `id` | `uuid` | PRIMARY KEY, DEFAULT `gen_random_uuid()` | Band ID |
| `user_id` | `uuid` | FOREIGN KEY → `users.id`, NOT NULL | Creator user |
| `name` | `text` | NOT NULL | Band name (AI-generated) |
| `bio` | `text` | NULL | Band bio (AI-generated) |
| `cover_url` | `text` | NULL | Cover image URL (placeholder for MVP) |
| `style_vector` | `vector(768)` | NULL | Average embedding of band tracks |
| `track_count` | `integer` | DEFAULT `0` | Number of tracks in band |
| `follower_count` | `integer` | DEFAULT `0` | Number of followers |
| `is_public` | `boolean` | DEFAULT `true` | Public visibility |
| `created_at` | `timestamptz` | DEFAULT `now()` | Creation time |
| `updated_at` | `timestamptz` | DEFAULT `now()` | Last update time |

**Indexes**:
- `idx_bands_user_id` on `user_id`
- `idx_bands_style_vector` using `ivfflat` (pgvector) for similarity search
- `idx_bands_created_at` on `created_at DESC`

**RLS Policies**:
- Public read access for public bands
- Users can read/update their own bands
- Service role can read/insert/update all

---

### 6. `band_tracks`

Junction table linking bands to tracks.

| Column | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `band_id` | `uuid` | FOREIGN KEY → `bands.id`, PRIMARY KEY | Band ID |
| `track_id` | `uuid` | FOREIGN KEY → `generated_tracks.id`, PRIMARY KEY | Track ID |
| `added_at` | `timestamptz` | DEFAULT `now()` | When track was added to band |

**Indexes**:
- `idx_band_tracks_band_id` on `band_id`
- `idx_band_tracks_track_id` on `track_id`

**RLS Policies**:
- Public read access
- Users can insert/delete their own band tracks
- Service role can read/insert/delete all

---

### 7. `user_playlists`

User-created playlists.

| Column | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `id` | `uuid` | PRIMARY KEY, DEFAULT `gen_random_uuid()` | Playlist ID |
| `user_id` | `uuid` | FOREIGN KEY → `users.id`, NOT NULL | Owner user |
| `name` | `text` | NOT NULL | Playlist name |
| `description` | `text` | NULL | Playlist description |
| `tracks` | `jsonb` | DEFAULT `'[]'::jsonb` | Array of track IDs (ordered) |
| `is_public` | `boolean` | DEFAULT `false` | Public visibility |
| `created_at` | `timestamptz` | DEFAULT `now()` | Creation time |
| `updated_at` | `timestamptz` | DEFAULT `now()` | Last update time |

**Indexes**:
- `idx_user_playlists_user_id` on `user_id`
- `idx_user_playlists_created_at` on `created_at DESC`

**RLS Policies**:
- Users can read their own playlists + public playlists
- Users can insert/update/delete their own playlists
- Service role can read/insert/update/delete all

**Example `tracks` JSON**:
```json
[
  {"id": "uuid-1", "added_at": "2025-01-15T10:30:00Z"},
  {"id": "uuid-2", "added_at": "2025-01-15T11:00:00Z"}
]
```

---

### 8. `user_library`

User's liked/saved tracks (like Spotify's "Liked Songs").

| Column | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `id` | `uuid` | PRIMARY KEY, DEFAULT `gen_random_uuid()` | Library entry ID |
| `user_id` | `uuid` | FOREIGN KEY → `users.id`, NOT NULL | User ID |
| `track_id` | `uuid` | FOREIGN KEY → `generated_tracks.id`, NOT NULL | Track ID |
| `added_at` | `timestamptz` | DEFAULT `now()` | When track was added |

**Indexes**:
- `idx_user_library_user_id` on `user_id`
- `idx_user_library_track_id` on `track_id`
- `idx_user_library_user_track` UNIQUE on `(user_id, track_id)` (prevent duplicates)

**RLS Policies**:
- Users can read/insert/delete their own library entries
- Service role can read/insert/delete all

---

### 9. `user_follows`

Users following bands.

| Column | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `user_id` | `uuid` | FOREIGN KEY → `users.id`, PRIMARY KEY | Follower user |
| `band_id` | `uuid` | FOREIGN KEY → `bands.id`, PRIMARY KEY | Band being followed |
| `created_at` | `timestamptz` | DEFAULT `now()` | Follow time |

**Indexes**:
- `idx_user_follows_user_id` on `user_id`
- `idx_user_follows_band_id` on `band_id`

**RLS Policies**:
- Users can read/insert/delete their own follows
- Service role can read/insert/delete all

---

### 10. `oauth_connections`

OAuth tokens for Spotify/Apple/YouTube.

| Column | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `id` | `uuid` | PRIMARY KEY, DEFAULT `gen_random_uuid()` | Connection ID |
| `user_id` | `uuid` | FOREIGN KEY → `users.id`, NOT NULL | User ID |
| `platform` | `text` | NOT NULL | Platform: `spotify`, `apple`, `youtube` |
| `access_token` | `text` | NOT NULL | Encrypted access token |
| `refresh_token` | `text` | NULL | Encrypted refresh token |
| `expires_at` | `timestamptz` | NULL | Token expiration time |
| `last_synced_at` | `timestamptz` | NULL | Last playlist sync time |
| `created_at` | `timestamptz` | DEFAULT `now()` | Connection time |
| `updated_at` | `timestamptz` | DEFAULT `now()` | Last update time |

**Indexes**:
- `idx_oauth_connections_user_id` on `user_id`
- `idx_oauth_connections_platform` on `platform`
- `idx_oauth_connections_user_platform` UNIQUE on `(user_id, platform)`

**RLS Policies**:
- Users can read/update/delete their own connections
- Service role can read/insert/update/delete all

**Note**: Tokens should be encrypted using Supabase Vault or application-level encryption.

---

## Extensions

```sql
-- Enable pgvector for similarity search
CREATE EXTENSION IF NOT EXISTS vector;

-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

---

## Functions & Triggers

### 1. `update_updated_at()`

Automatically update `updated_at` timestamp.

```sql
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

**Applied to**:
- `users.updated_at`
- `bands.updated_at`
- `user_playlists.updated_at`
- `oauth_connections.updated_at`

### 2. `increment_band_track_count()`

Auto-increment `bands.track_count` when track added.

```sql
CREATE OR REPLACE FUNCTION increment_band_track_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE bands SET track_count = track_count + 1 WHERE id = NEW.band_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

**Trigger**: After INSERT on `band_tracks`

### 3. `reset_daily_count()`

Reset daily generation counter at midnight UTC (Edge Function, not DB function).

---

## Row Level Security (RLS)

All tables have RLS enabled. Policies:

1. **Users can read/update their own data**
2. **Public read access** for: `embeddings`, public `bands`, public `playlists`
3. **Service role** has full access (for backend operations)

---

## Migration Strategy

1. Create migrations in `/supabase/migrations/` directory
2. Run migrations via Supabase CLI: `supabase db push`
3. Test migrations on local Supabase instance first
4. Apply to production via CLI or Dashboard

---

## Performance Considerations

- **pgvector indexes**: Use `ivfflat` with `lists = 100` for fast similarity search
- **Composite indexes**: On frequently queried column pairs (`user_id, created_at`)
- **JSONB indexes**: GIN indexes on `preferences_profile` if needed for queries
- **Connection pooling**: Use Supabase connection pooler for serverless functions

---

## Backup & Recovery

- **Daily backups**: Supabase Pro includes automatic daily backups (7-day retention)
- **Point-in-time recovery**: Available on Pro tier
- **Manual exports**: Use `pg_dump` for manual backups

---

## Environment Variables

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://djszkpgtwhdjhexnjdof.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=sb_publishable_cK8kjrpekz2ssEwQOBvbtw_yxM37UGQ
SUPABASE_SERVICE_ROLE_KEY=sb_secret_Nfa9TqrXPq6v-nKqb19nFg_B3FukR8X
```

---

## Next Steps

1. ✅ Create migration files for all tables
2. ✅ Set up RLS policies
3. ✅ Create database functions and triggers
4. ✅ Test migrations locally
5. ✅ Apply to production

