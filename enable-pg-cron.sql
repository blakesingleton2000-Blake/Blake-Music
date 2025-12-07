-- Enable pg_cron Extension
-- Run this FIRST in Supabase SQL Editor

-- Enable the pg_cron extension
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Grant usage on schema cron to postgres (required)
GRANT USAGE ON SCHEMA cron TO postgres;

-- Verify extension is enabled
SELECT * FROM pg_extension WHERE extname = 'pg_cron';

