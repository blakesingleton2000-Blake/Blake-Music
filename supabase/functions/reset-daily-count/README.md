# Reset Daily Counter Edge Function

This Edge Function resets the `daily_count` field for all free users at midnight UTC.

## Setup

1. **Deploy the function**:
   ```bash
   supabase functions deploy reset-daily-count
   ```

2. **Set up cron job** (via Supabase Dashboard):
   - Go to **Database** → **Cron Jobs**
   - Create new cron job:
     - Name: `reset_daily_count`
     - Schedule: `0 0 * * *` (midnight UTC daily)
     - SQL:
       ```sql
       SELECT net.http_post(
         url := 'https://djszkpgtwhdjhexnjdof.supabase.co/functions/v1/reset-daily-count',
         headers := '{"Authorization": "Bearer YOUR_SERVICE_ROLE_KEY"}'::jsonb
       );
       ```

## Manual Testing

Test the function manually:

```bash
curl -X POST https://djszkpgtwhdjhexnjdof.supabase.co/functions/v1/reset-daily-count \
  -H "Authorization: Bearer YOUR_SERVICE_ROLE_KEY"
```

## Alternative: pg_cron (if available)

If your Supabase plan supports `pg_cron`, you can use a simpler SQL function:

```sql
SELECT cron.schedule(
  'reset-daily-count',
  '0 0 * * *',
  $$
  UPDATE users SET daily_count = 0 WHERE premium = false;
  $$
);
```

