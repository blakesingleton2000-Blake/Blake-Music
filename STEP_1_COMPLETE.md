# Step 1: Apply Supabase Migrations

## Quick Method - Run This Script

```bash
cd /Users/blakesingleton/Desktop/Music
./apply-migrations-cli.sh
```

This will:
1. Check if you're logged in (prompts login if needed)
2. Link to your Supabase project
3. Apply all migrations
4. Create all 10 tables

---

## Manual Method - Via Dashboard

If CLI doesn't work, use the dashboard:

1. **Open**: https://djszkpgtwhdjhexnjdof.supabase.co
2. **Click**: SQL Editor (left sidebar)
3. **Click**: New Query
4. **Open file**: `supabase/migrations/20250107000000_initial_schema.sql`
5. **Copy ALL** contents (Cmd+A, Cmd+C)
6. **Paste** into SQL Editor
7. **Click**: Run (or Cmd+Enter)
8. **Wait**: ~15-20 seconds

---

## Verify Success ✅

After applying migrations:

1. **Go to**: Table Editor (left sidebar)
2. **Should see 10 tables**:
   - ✅ users
   - ✅ user_history
   - ✅ embeddings
   - ✅ generated_tracks
   - ✅ bands
   - ✅ band_tracks
   - ✅ user_playlists
   - ✅ user_library
   - ✅ user_follows
   - ✅ oauth_connections

---

## Test Query

Run this in SQL Editor to verify:

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
```

Should return **10 rows**.

---

## ✅ Once Complete

After tables are created:
- ✅ Database schema ready
- ✅ RLS policies active
- ✅ Ready to test app

**Then we can continue building features!**

