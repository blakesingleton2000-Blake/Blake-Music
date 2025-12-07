# Deploy Daily Counter Reset Edge Function

## Quick Deploy

### Option 1: Via Supabase CLI

```bash
cd supabase
supabase functions deploy reset-daily-count
```

### Option 2: Via Supabase Dashboard

1. Go to: https://djszkpgtwhdjhexnjdof.supabase.co
2. Click **Edge Functions** in left sidebar
3. Click **Create Function**
4. Name: `reset-daily-count`
5. Copy contents of `supabase/functions/reset-daily-count/index.ts`
6. Paste into editor
7. Click **Deploy**

## Set Up Cron Job

After deploying:

1. Go to **Database** → **Cron Jobs** (or **Database** → **Extensions** → **pg_cron**)
2. Click **New Cron Job**
3. Configure:
   - **Name**: `reset_daily_count`
   - **Schedule**: `0 0 * * *` (midnight UTC daily)
   - **Command**: 
     ```sql
     SELECT net.http_post(
       url := 'https://djszkpgtwhdjhexnjdof.supabase.co/functions/v1/reset-daily-count',
       headers := '{"Authorization": "Bearer YOUR_SERVICE_ROLE_KEY"}'::jsonb
     );
     ```
   - **Enabled**: Yes

## Test Manually

Test the function:

```bash
curl -X POST https://djszkpgtwhdjhexnjdof.supabase.co/functions/v1/reset-daily-count \
  -H "Authorization: Bearer YOUR_SERVICE_ROLE_KEY"
```

Should return:
```json
{
  "success": true,
  "reset_count": 0,
  "timestamp": "..."
}
```

---

**Status**: Code ready, needs deployment + cron setup

