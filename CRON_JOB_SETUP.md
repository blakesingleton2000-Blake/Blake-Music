# Set Up Cron Job - Step by Step

## ⚠️ Important: SQL Must Be Run in Supabase Dashboard

The SQL command you tried to run in terminal needs to be run in **Supabase SQL Editor**, not your terminal!

## Steps:

### 1. Go to Supabase Dashboard
- Visit: https://supabase.com/dashboard
- Select your project: `Music`

### 2. Open SQL Editor
- Click **SQL Editor** in the left sidebar
- Click **New Query**

### 3. Enable pg_cron Extension (Run This First!)

```sql
-- Enable the pg_cron extension
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Grant usage on schema cron to postgres
GRANT USAGE ON SCHEMA cron TO postgres;
```

**Click "Run"** - You should see "Success. No rows returned"

### 4. Set Up Cron Job (Run This Second)

```sql
SELECT cron.schedule(
  'reset-daily-count',
  '0 0 * * *',
  $$
  SELECT net.http_post(
    url := 'https://djszkpgtwhdjhexnjdof.supabase.co/functions/v1/reset-daily-count',
    headers := '{"Authorization": "Bearer sb_secret_Nfa9TqrXPq6v-nKqb19nFg_B3FukR8X"}'::jsonb
  );
  $$
);
```

### 4. Click "Run" (or press Cmd+Enter)

### 5. Verify
You should see a response like:
```
schedule
--------
1
```

This means the cron job is scheduled!

---

## Alternative: Use pg_cron Extension

If the above doesn't work, you might need to enable the pg_cron extension first:

```sql
-- Enable pg_cron extension
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Then run the schedule command above
```

---

## Test the Function Manually

After setting up the cron, test it works:

```bash
curl -X POST https://djszkpgtwhdjhexnjdof.supabase.co/functions/v1/reset-daily-count \
  -H "Authorization: Bearer sb_secret_Nfa9TqrXPq6v-nKqb19nFg_B3FukR8X"
```

You should get:
```json
{
  "success": true,
  "reset_count": 0,
  "timestamp": "..."
}
```

---

**Remember**: SQL commands go in Supabase SQL Editor, not your terminal! 🎯

