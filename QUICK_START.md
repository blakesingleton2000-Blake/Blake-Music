# Quick Start Guide

## Step 1: Apply Database Migrations (2 minutes)

### Option A: Via Supabase Dashboard (Easiest) ⭐

1. Open: https://djszkpgtwhdjhexnjdof.supabase.co
2. Click **SQL Editor** in left sidebar
3. Click **New Query**
4. Open file: `supabase/migrations/20250107000000_initial_schema.sql`
5. Copy ALL contents (Cmd+A, Cmd+C)
6. Paste into SQL Editor
7. Click **Run** (or press Cmd+Enter)
8. Wait ~10 seconds for completion
9. Verify: Click **Table Editor** → Should see 10 tables

### Option B: Via CLI Script

```bash
./apply-migrations.sh
```

---

## Step 2: Verify Migrations Applied ✅

Run this in SQL Editor:

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;
```

Should see:
- bands
- band_tracks
- embeddings
- generated_tracks
- oauth_connections
- user_follows
- user_history
- user_library
- user_playlists
- users

---

## Step 3: Next.js + Vercel Setup

See `SETUP_NEXTJS_VERCEL.md` for detailed instructions.

