# Supabase Migrations Guide

## Applying Migrations

### Option 1: Via Supabase CLI (Recommended)

1. **Login to Supabase**:
   ```bash
   supabase login
   ```

2. **Link to your project**:
   ```bash
   supabase link --project-ref djszkpgtwhdjhexnjdof
   ```

3. **Apply migrations**:
   ```bash
   supabase db push
   ```

### Option 2: Via Supabase Dashboard

1. Go to your Supabase project: https://djszkpgtwhdjhexnjdof.supabase.co
2. Navigate to **SQL Editor**
3. Copy the contents of `20250107000000_initial_schema.sql`
4. Paste and run the SQL

### Option 3: Via psql (Direct Database Connection)

```bash
psql "postgresql://postgres:[YOUR-PASSWORD]@db.djszkpgtwhdjhexnjdof.supabase.co:5432/postgres" -f supabase/migrations/20250107000000_initial_schema.sql
```

## Verifying Migrations

After applying, verify tables exist:

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;
```

You should see:
- users
- user_history
- embeddings
- generated_tracks
- bands
- band_tracks
- user_playlists
- user_library
- user_follows
- oauth_connections

## Testing RLS Policies

Test that RLS is working:

```sql
-- Should only see your own user
SELECT * FROM users;

-- Should only see your own history
SELECT * FROM user_history;
```

## Next Steps

1. ✅ Apply initial schema migration
2. ✅ Set up Edge Function for daily counter reset
3. ✅ Test RLS policies
4. ✅ Seed initial data (optional)

