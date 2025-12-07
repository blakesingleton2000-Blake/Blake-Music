-- Function to find similar tracks using pgvector
-- This function uses cosine similarity to find tracks similar to a user's taste_vector

CREATE OR REPLACE FUNCTION match_tracks(
  query_embedding vector(768),
  match_threshold float DEFAULT 0.7,
  match_count int DEFAULT 10
)
RETURNS TABLE (
  id uuid,
  url text,
  duration integer,
  explanation text,
  distance float
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    gt.id,
    gt.url,
    gt.duration,
    gt.explanation,
    1 - (gt.user_id::text <-> query_embedding::text::vector) as distance
  FROM generated_tracks gt
  WHERE gt.status = 'completed'
  ORDER BY gt.user_id::text <-> query_embedding::text::vector
  LIMIT match_count;
END;
$$;

-- Alternative: Match against embeddings table for real music
CREATE OR REPLACE FUNCTION match_embeddings(
  query_embedding vector(768),
  match_threshold float DEFAULT 0.7,
  match_count int DEFAULT 10
)
RETURNS TABLE (
  id uuid,
  track_id text,
  track_name text,
  artist text,
  vector vector(768),
  distance float
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    e.id,
    e.track_id,
    e.track_name,
    e.artist,
    e.vector,
    1 - (e.vector <=> query_embedding) as distance
  FROM embeddings e
  WHERE 1 - (e.vector <=> query_embedding) > match_threshold
  ORDER BY e.vector <=> query_embedding
  LIMIT match_count;
END;
$$;

