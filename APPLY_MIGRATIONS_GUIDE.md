# Apply Database Migrations - Step by Step Guide

## Overview

You need to apply 2 migration files to set up the complete database schema.

## Step 1: Apply Main Schema

1. **Go to Supabase Dashboard**:
   - Visit: https://djszkpgtwhdjhexnjdof.supabase.co
   - Login with your Supabase account

2. **Open SQL Editor**:
   - Click **SQL Editor** in the left sidebar
   - Click **New Query**

3. **Copy Migration File**:
   - Open: `supabase/migrations/20250107000000_initial_schema.sql`
   - Copy **ALL** contents (Ctrl+A, Ctrl+C)

4. **Paste and Run**:
   - Paste into SQL Editor
   - Click **Run** (or press Ctrl+Enter)
   - Wait for completion (should take 10-30 seconds)

5. **Verify Tables Created**:
   - Go to **Table Editor** in left sidebar
   - You should see 10 tables:
     - users
     - user_history
     - embeddings
     - bands
     - generated_tracks
     - band_tracks
     - user_playlists
     - user_library
     - user_follows
     - oauth_connections

## Step 2: Apply Recommendations Function

1. **Open SQL Editor Again**:
   - Click **SQL Editor** → **New Query**

2. **Copy Function File**:
   - Open: `supabase/migrations/20250107000001_recommendations_function.sql`
   - Copy **ALL** contents

3. **Paste and Run**:
   - Paste into SQL Editor
   - Click **Run**

4. **Verify Function Created**:
   - Run this query:
   ```sql
   SELECT proname FROM pg_proc WHERE proname = 'match_tracks';
   ```
   - Should return 1 row

## Step 3: Set Up Storage Bucket

1. **Open SQL Editor**:
   - Click **SQL Editor** → **New Query**

2. **Copy Storage Setup**:
   - Open: `supabase/storage-setup.sql`
   - Copy **ALL** contents

3. **Paste and Run**:
   - Paste into SQL Editor
   - Click **Run**

4. **Verify Bucket Created**:
   - Go to **Storage** in left sidebar
   - You should see `audio` bucket

## Step 4: Verify Everything

Run this verification query:

```sql
-- Check tables
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Check functions
SELECT proname FROM pg_proc WHERE proname LIKE 'match%';

-- Check storage bucket
SELECT name FROM storage.buckets WHERE id = 'audio';
```

Should return:
- 10 tables
- 2 functions (match_tracks, match_embeddings)
- 1 storage bucket (audio)

## Troubleshooting

### Error: "relation already exists"
- Some tables might already exist
- This is okay, the migration uses `CREATE TABLE IF NOT EXISTS`
- Continue with next steps

### Error: "permission denied"
- Make sure you're logged in as project owner
- Check that you have admin access

### Error: "extension vector does not exist"
- Run this first:
  ```sql
  CREATE EXTENSION IF NOT EXISTS vector;
  ```
- Then retry the migration

## Next Steps

After migrations are applied:
1. ✅ Database schema ready
2. ✅ Storage bucket ready
3. ⏭️ Add environment variables
4. ⏭️ Deploy RunPod template
5. ⏭️ Test the app

