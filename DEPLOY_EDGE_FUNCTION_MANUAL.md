# Deploy Edge Function - Manual Steps

Since automated login isn't possible, follow these steps:

## Step 1: Login to Supabase CLI

Open your terminal and run:

```bash
cd /Users/blakesingleton/Desktop/Music
supabase login
```

This will open your browser for authentication.

## Step 2: Link to Your Project

```bash
supabase link --project-ref djszkpgtwhdjhexnjdof
```

When prompted, enter your database password from:
- Supabase Dashboard → Settings → Database → Database password

## Step 3: Deploy the Function

```bash
cd supabase
supabase functions deploy reset-daily-count --no-verify-jwt
```

## Step 4: Set Up Cron Job

1. Go to Supabase Dashboard → Database → Cron Jobs (or Extensions → pg_cron)
2. Click "New Cron Job" or run this SQL:

```sql
SELECT cron.schedule(
  'reset-daily-count',
  '0 0 * * *',  -- Run at midnight UTC daily
  $$
  SELECT net.http_post(
    url := 'https://djszkpgtwhdjhexnjdof.supabase.co/functions/v1/reset-daily-count',
    headers := '{"Authorization": "Bearer sb_secret_Nfa9TqrXPq6v-nKqb19nFg_B3FukR8X"}'::jsonb
  );
  $$
);
```

**Note**: Replace the Bearer token with your actual service role key if different.

## Step 5: Verify

Test the function manually:

```bash
curl -X POST https://djszkpgtwhdjhexnjdof.supabase.co/functions/v1/reset-daily-count \
  -H "Authorization: Bearer sb_secret_Nfa9TqrXPq6v-nKqb19nFg_B3FukR8X"
```

You should get a response like:
```json
{
  "success": true,
  "reset_count": 0,
  "timestamp": "2025-12-07T..."
}
```

---

**Alternative**: If you prefer, you can also deploy via Supabase Dashboard:
1. Go to Edge Functions
2. Click "Deploy Function"
3. Upload the `supabase/functions/reset-daily-count` folder

