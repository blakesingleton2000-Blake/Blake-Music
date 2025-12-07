-- Infinite Player - Initial Database Schema
-- Created: January 2025
-- Description: Complete schema for MVP including users, tracks, bands, playlists, and vector search

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "vector";

-- ============================================================================
-- TABLES
-- ============================================================================

-- 1. Users table
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  taste_vector vector(768),
  preferences_profile JSONB DEFAULT '{}'::jsonb,
  daily_count INTEGER DEFAULT 0,
  premium BOOLEAN DEFAULT false,
  onboarding_completed BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 2. User history (listening history from OAuth and app)
CREATE TABLE IF NOT EXISTS user_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  platform TEXT NOT NULL, -- 'spotify', 'apple', 'youtube', 'infinite'
  track_id TEXT,
  track_name TEXT NOT NULL,
  artist TEXT NOT NULL,
  album TEXT,
  played_at TIMESTAMPTZ DEFAULT now(),
  play_count INTEGER DEFAULT 1
);

-- 3. Embeddings (cached music embeddings)
CREATE TABLE IF NOT EXISTS embeddings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  track_id TEXT UNIQUE,
  track_name TEXT NOT NULL,
  artist TEXT NOT NULL,
  vector vector(768) NOT NULL,
  genre TEXT[] DEFAULT '{}',
  source TEXT NOT NULL, -- 'musicbrainz', 'spotify', 'fma', 'jamendo'
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 4. Generated tracks (AI-generated music)
CREATE TABLE IF NOT EXISTS generated_tracks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  url TEXT NOT NULL,
  duration INTEGER NOT NULL,
  mode TEXT NOT NULL, -- 'new', 'similar', 'extend', 'radio'
  source_id UUID REFERENCES generated_tracks(id),
  source_external_id TEXT,
  explanation TEXT,
  match_percentage INTEGER,
  status TEXT DEFAULT 'completed', -- 'queued', 'generating', 'completed', 'failed'
  band_id UUID REFERENCES bands(id),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 5. Bands (AI-generated band profiles)
CREATE TABLE IF NOT EXISTS bands (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  bio TEXT,
  cover_url TEXT,
  style_vector vector(768),
  track_count INTEGER DEFAULT 0,
  follower_count INTEGER DEFAULT 0,
  is_public BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 6. Band tracks (junction table)
CREATE TABLE IF NOT EXISTS band_tracks (
  band_id UUID NOT NULL REFERENCES bands(id) ON DELETE CASCADE,
  track_id UUID NOT NULL REFERENCES generated_tracks(id) ON DELETE CASCADE,
  added_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (band_id, track_id)
);

-- 7. User playlists
CREATE TABLE IF NOT EXISTS user_playlists (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  tracks JSONB DEFAULT '[]'::jsonb,
  is_public BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 8. User library (liked songs)
CREATE TABLE IF NOT EXISTS user_library (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  track_id UUID NOT NULL REFERENCES generated_tracks(id) ON DELETE CASCADE,
  added_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, track_id)
);

-- 9. User follows (following bands)
CREATE TABLE IF NOT EXISTS user_follows (
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  band_id UUID NOT NULL REFERENCES bands(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (user_id, band_id)
);

-- 10. OAuth connections
CREATE TABLE IF NOT EXISTS oauth_connections (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  platform TEXT NOT NULL, -- 'spotify', 'apple', 'youtube'
  access_token TEXT NOT NULL,
  refresh_token TEXT,
  expires_at TIMESTAMPTZ,
  last_synced_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, platform)
);

-- ============================================================================
-- INDEXES
-- ============================================================================

-- Users indexes
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_taste_vector ON users USING ivfflat (taste_vector vector_cosine_ops) WITH (lists = 100);

-- User history indexes
CREATE INDEX IF NOT EXISTS idx_user_history_user_id ON user_history(user_id);
CREATE INDEX IF NOT EXISTS idx_user_history_played_at ON user_history(played_at DESC);
CREATE INDEX IF NOT EXISTS idx_user_history_user_played ON user_history(user_id, played_at DESC);

-- Embeddings indexes
CREATE INDEX IF NOT EXISTS idx_embeddings_track_id ON embeddings(track_id);
CREATE INDEX IF NOT EXISTS idx_embeddings_vector ON embeddings USING ivfflat (vector vector_cosine_ops) WITH (lists = 100);
CREATE INDEX IF NOT EXISTS idx_embeddings_artist ON embeddings(artist);

-- Generated tracks indexes
CREATE INDEX IF NOT EXISTS idx_generated_tracks_user_id ON generated_tracks(user_id);
CREATE INDEX IF NOT EXISTS idx_generated_tracks_created_at ON generated_tracks(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_generated_tracks_band_id ON generated_tracks(band_id);
CREATE INDEX IF NOT EXISTS idx_generated_tracks_status ON generated_tracks(status);

-- Bands indexes
CREATE INDEX IF NOT EXISTS idx_bands_user_id ON bands(user_id);
CREATE INDEX IF NOT EXISTS idx_bands_style_vector ON bands USING ivfflat (style_vector vector_cosine_ops) WITH (lists = 100);
CREATE INDEX IF NOT EXISTS idx_bands_created_at ON bands(created_at DESC);

-- Band tracks indexes
CREATE INDEX IF NOT EXISTS idx_band_tracks_band_id ON band_tracks(band_id);
CREATE INDEX IF NOT EXISTS idx_band_tracks_track_id ON band_tracks(track_id);

-- User playlists indexes
CREATE INDEX IF NOT EXISTS idx_user_playlists_user_id ON user_playlists(user_id);
CREATE INDEX IF NOT EXISTS idx_user_playlists_created_at ON user_playlists(created_at DESC);

-- User library indexes
CREATE INDEX IF NOT EXISTS idx_user_library_user_id ON user_library(user_id);
CREATE INDEX IF NOT EXISTS idx_user_library_track_id ON user_library(track_id);

-- User follows indexes
CREATE INDEX IF NOT EXISTS idx_user_follows_user_id ON user_follows(user_id);
CREATE INDEX IF NOT EXISTS idx_user_follows_band_id ON user_follows(band_id);

-- OAuth connections indexes
CREATE INDEX IF NOT EXISTS idx_oauth_connections_user_id ON oauth_connections(user_id);
CREATE INDEX IF NOT EXISTS idx_oauth_connections_platform ON oauth_connections(platform);

-- ============================================================================
-- FUNCTIONS
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to increment band track count
CREATE OR REPLACE FUNCTION increment_band_track_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE bands SET track_count = track_count + 1 WHERE id = NEW.band_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to decrement band track count
CREATE OR REPLACE FUNCTION decrement_band_track_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE bands SET track_count = GREATEST(0, track_count - 1) WHERE id = OLD.band_id;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Function to increment band follower count
CREATE OR REPLACE FUNCTION increment_band_follower_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE bands SET follower_count = follower_count + 1 WHERE id = NEW.band_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to decrement band follower count
CREATE OR REPLACE FUNCTION decrement_band_follower_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE bands SET follower_count = GREATEST(0, follower_count - 1) WHERE id = OLD.band_id;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- TRIGGERS
-- ============================================================================

-- Update updated_at on users
CREATE TRIGGER update_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- Update updated_at on bands
CREATE TRIGGER update_bands_updated_at
  BEFORE UPDATE ON bands
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- Update updated_at on user_playlists
CREATE TRIGGER update_user_playlists_updated_at
  BEFORE UPDATE ON user_playlists
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- Update updated_at on oauth_connections
CREATE TRIGGER update_oauth_connections_updated_at
  BEFORE UPDATE ON oauth_connections
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- Increment band track count
CREATE TRIGGER increment_band_track_count_trigger
  AFTER INSERT ON band_tracks
  FOR EACH ROW
  EXECUTE FUNCTION increment_band_track_count();

-- Decrement band track count
CREATE TRIGGER decrement_band_track_count_trigger
  AFTER DELETE ON band_tracks
  FOR EACH ROW
  EXECUTE FUNCTION decrement_band_track_count();

-- Increment band follower count
CREATE TRIGGER increment_band_follower_count_trigger
  AFTER INSERT ON user_follows
  FOR EACH ROW
  EXECUTE FUNCTION increment_band_follower_count();

-- Decrement band follower count
CREATE TRIGGER decrement_band_follower_count_trigger
  AFTER DELETE ON user_follows
  FOR EACH ROW
  EXECUTE FUNCTION decrement_band_follower_count();

-- ============================================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE embeddings ENABLE ROW LEVEL SECURITY;
ALTER TABLE generated_tracks ENABLE ROW LEVEL SECURITY;
ALTER TABLE bands ENABLE ROW LEVEL SECURITY;
ALTER TABLE band_tracks ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_playlists ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_library ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_follows ENABLE ROW LEVEL SECURITY;
ALTER TABLE oauth_connections ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Users can read own profile"
  ON users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON users FOR UPDATE
  USING (auth.uid() = id);

-- User history policies
CREATE POLICY "Users can read own history"
  ON user_history FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own history"
  ON user_history FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Embeddings policies (public read)
CREATE POLICY "Anyone can read embeddings"
  ON embeddings FOR SELECT
  USING (true);

-- Generated tracks policies
CREATE POLICY "Users can read own tracks"
  ON generated_tracks FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can read public tracks"
  ON generated_tracks FOR SELECT
  USING (true); -- Public tracks are visible to all

CREATE POLICY "Users can insert own tracks"
  ON generated_tracks FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own tracks"
  ON generated_tracks FOR UPDATE
  USING (auth.uid() = user_id);

-- Bands policies
CREATE POLICY "Anyone can read public bands"
  ON bands FOR SELECT
  USING (is_public = true OR auth.uid() = user_id);

CREATE POLICY "Users can read own bands"
  ON bands FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own bands"
  ON bands FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own bands"
  ON bands FOR UPDATE
  USING (auth.uid() = user_id);

-- Band tracks policies
CREATE POLICY "Anyone can read band tracks"
  ON band_tracks FOR SELECT
  USING (true);

CREATE POLICY "Users can manage own band tracks"
  ON band_tracks FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM bands
      WHERE bands.id = band_tracks.band_id
      AND bands.user_id = auth.uid()
    )
  );

-- User playlists policies
CREATE POLICY "Users can read own playlists"
  ON user_playlists FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can read public playlists"
  ON user_playlists FOR SELECT
  USING (is_public = true);

CREATE POLICY "Users can insert own playlists"
  ON user_playlists FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own playlists"
  ON user_playlists FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own playlists"
  ON user_playlists FOR DELETE
  USING (auth.uid() = user_id);

-- User library policies
CREATE POLICY "Users can read own library"
  ON user_library FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own library"
  ON user_library FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own library"
  ON user_library FOR DELETE
  USING (auth.uid() = user_id);

-- User follows policies
CREATE POLICY "Users can read own follows"
  ON user_follows FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own follows"
  ON user_follows FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own follows"
  ON user_follows FOR DELETE
  USING (auth.uid() = user_id);

-- OAuth connections policies
CREATE POLICY "Users can read own connections"
  ON oauth_connections FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own connections"
  ON oauth_connections FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own connections"
  ON oauth_connections FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own connections"
  ON oauth_connections FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================================================
-- COMMENTS
-- ============================================================================

COMMENT ON TABLE users IS 'Core user accounts with taste vectors and preferences';
COMMENT ON TABLE user_history IS 'User listening history from OAuth imports and app usage';
COMMENT ON TABLE embeddings IS 'Cached music embeddings for similarity search';
COMMENT ON TABLE generated_tracks IS 'AI-generated music tracks';
COMMENT ON TABLE bands IS 'AI-generated band profiles with grouped tracks';
COMMENT ON TABLE band_tracks IS 'Junction table linking bands to tracks';
COMMENT ON TABLE user_playlists IS 'User-created playlists';
COMMENT ON TABLE user_library IS 'User liked/saved tracks';
COMMENT ON TABLE user_follows IS 'Users following bands';
COMMENT ON TABLE oauth_connections IS 'OAuth tokens for Spotify/Apple/YouTube';

