# Apply Supabase Migrations - Step by Step

## Quick Method (Dashboard) ⭐

1. **Open Supabase Dashboard**:
   - Go to: https://djszkpgtwhdjhexnjdof.supabase.co
   - Click **SQL Editor** in the left sidebar

2. **Open Migration File**:
   - In your file explorer, open: `supabase/migrations/20250107000000_initial_schema.sql`
   - Select ALL contents (Cmd+A / Ctrl+A)
   - Copy (Cmd+C / Ctrl+C)

3. **Paste & Run**:
   - In Supabase SQL Editor, click **New Query**
   - Paste the SQL (Cmd+V / Ctrl+V)
   - Click **Run** button (or press Cmd+Enter / Ctrl+Enter)
   - Wait ~10-15 seconds for completion

4. **Verify Success**:
   - You should see: "Success. No rows returned"
   - Click **Table Editor** in left sidebar
   - You should see 10 tables:
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

5. **Test RLS**:
   - In SQL Editor, run:
     ```sql
     SELECT COUNT(*) FROM users;
     ```
   - Should return a count (even if 0)

✅ **Migrations Applied!**

