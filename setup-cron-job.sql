-- Set Up Daily Counter Reset Cron Job
-- Run this AFTER enabling pg_cron extension

-- Schedule the cron job to run daily at midnight UTC
SELECT cron.schedule(
  'reset-daily-count',
  '0 0 * * *',  -- Cron expression: minute=0, hour=0, every day
  $$
  SELECT net.http_post(
    url := 'https://djszkpgtwhdjhexnjdof.supabase.co/functions/v1/reset-daily-count',
    headers := '{"Authorization": "Bearer sb_secret_Nfa9TqrXPq6v-nKqb19nFg_B3FukR8X"}'::jsonb
  );
  $$
);

-- Verify cron job was created
SELECT * FROM cron.job WHERE jobname = 'reset-daily-count';

