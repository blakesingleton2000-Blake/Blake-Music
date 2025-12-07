# 🚀 Deploy Edge Function - Final Instructions

## Edge Function: reset-daily-count

**Purpose**: Resets `daily_count` to 0 for all free users at midnight UTC daily.

---

## Step 1: Deploy Function

```bash
cd supabase
supabase functions deploy reset-daily-count
```

**Or via Supabase Dashboard**:
1. Go to: https://supabase.com/dashboard/project/djszkpgtwhdjhexnjdof/functions
2. Click "Create a new function"
3. Name: `reset-daily-count`
4. Copy code from `supabase/functions/reset-daily-count/index.ts`
5. Click "Deploy"

---

## Step 2: Set Up Cron Job

**Option A: Via Supabase Dashboard (Easiest)**

1. Go to: https://supabase.com/dashboard/project/djszkpgtwhdjhexnjdof/database/extensions
2. Enable `pg_cron` extension if not already enabled
3. Go to SQL Editor
4. Run this SQL:

```sql
-- Create cron job to reset daily count at midnight UTC
SELECT cron.schedule(
  'reset-daily-count',
  '0 0 * * *', -- Every day at midnight UTC
  $$
  SELECT
    net.http_post(
      url := 'https://djszkpgtwhdjhexnjdof.supabase.co/functions/v1/reset-daily-count',
      headers := jsonb_build_object(
        'Authorization', 'Bearer ' || current_setting('app.settings.service_role_key', true)
      )
    ) AS request_id;
  $$
);
```

**Option B: Via SQL Editor Directly**

1. Go to: https://supabase.com/dashboard/project/djszkpgtwhdjhexnjdof/sql/new
2. Paste the SQL above
3. Click "Run"

---

## Step 3: Verify

**Check cron job**:
```sql
SELECT * FROM cron.job WHERE jobname = 'reset-daily-count';
```

**Test function manually**:
```bash
curl -X POST https://djszkpgtwhdjhexnjdof.supabase.co/functions/v1/reset-daily-count \
  -H "Authorization: Bearer YOUR_SERVICE_ROLE_KEY"
```

---

## ✅ Done!

The function will now run automatically every day at midnight UTC, resetting `daily_count` for all free users.

