# ✅ Migrations Ready to Apply

I've created a **combined migration file** with all SQL in one place.

## File Created: `combined-migration.sql`

This file contains:
- ✅ Main schema (10 tables)
- ✅ Recommendations function
- ✅ Storage setup

## Apply Now (Choose One Method):

### Method 1: Supabase SQL Editor (Easiest - 2 minutes)

1. **Open**: https://djszkpgtwhdjhexnjdof.supabase.co
2. **Click**: SQL Editor → New Query
3. **Open**: `combined-migration.sql` file
4. **Copy**: All contents (Cmd+A, Cmd+C)
5. **Paste**: Into SQL Editor
6. **Click**: Run button (or Cmd+Enter)
7. **Wait**: ~15-30 seconds

**Done!** ✅

---

### Method 2: Via CLI (If you're logged in)

```bash
cd /Users/blakesingleton/Desktop/Music

# If not logged in:
supabase login

# Link project:
supabase link --project-ref djszkpgtwhdjhexnjdof

# Apply:
cd supabase
supabase db execute --file ../combined-migration.sql
```

---

### Method 3: Direct psql (If you have password)

```bash
# Get connection string from Supabase Dashboard → Settings → Database
psql "postgresql://postgres:[PASSWORD]@db.djszkpgtwhdjhexnjdof.supabase.co:5432/postgres" -f combined-migration.sql
```

---

## Verify Success

After applying, run this in SQL Editor:

```sql
-- Should show 10 tables
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Should show 2 functions
SELECT proname FROM pg_proc WHERE proname LIKE 'match%';

-- Should show audio bucket
SELECT name FROM storage.buckets WHERE id = 'audio';
```

---

## ✅ Next Steps After Migrations

1. ✅ Database ready
2. ⏭️ Get API keys (see `ENV_TEMPLATE.md`)
3. ⏭️ Test locally (`cd app && npm run dev`)
4. ⏭️ Deploy RunPod (see `runpod/README.md`)

---

**The combined-migration.sql file is ready - just copy and paste into Supabase SQL Editor!** 🚀

