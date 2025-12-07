# Apply Supabase Migrations - Step by Step

## Method 1: Via Supabase CLI (Recommended)

Run these commands in your terminal:

```bash
cd /Users/blakesingleton/Desktop/Music

# Step 1: Login to Supabase (will open browser)
supabase login

# Step 2: Link to your project
supabase link --project-ref djszkpgtwhdjhexnjdof

# Step 3: Apply migrations
supabase db push
```

**Expected Output:**
```
Applying migration 20250107000000_initial_schema...
Finished supabase db push.
```

---

## Method 2: Via Supabase Dashboard (If CLI doesn't work)

1. **Open Supabase Dashboard**:
   - Go to: https://djszkpgtwhdjhexnjdof.supabase.co
   - Click **SQL Editor** in the left sidebar

2. **Open Migration File**:
   - In your file explorer, navigate to: `supabase/migrations/20250107000000_initial_schema.sql`
   - Open the file
   - Select ALL contents (Cmd+A / Ctrl+A)
   - Copy (Cmd+C / Ctrl+C)

3. **Paste & Run**:
   - In Supabase SQL Editor, click **New Query** button
   - Paste the SQL (Cmd+V / Ctrl+V)
   - Click **Run** button (or press Cmd+Enter / Ctrl+Enter)
   - Wait ~15-20 seconds for completion

4. **Verify Success**:
   - You should see: "Success. No rows returned" or similar
   - Click **Table Editor** in left sidebar
   - You should see **10 tables**:
     - ✅ bands
     - ✅ band_tracks
     - ✅ embeddings
     - ✅ generated_tracks
     - ✅ oauth_connections
     - ✅ user_follows
     - ✅ user_history
     - ✅ user_library
     - ✅ user_playlists
     - ✅ users

---

## Verify Tables Were Created

Run this query in SQL Editor:

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
```

Should return 10 rows with all table names.

---

## Test RLS Policies

Run this query (should only return your own user if logged in):

```sql
SELECT id, email, premium, daily_count 
FROM users 
LIMIT 5;
```

---

## ✅ Once Tables Are Created

After verifying tables exist:
1. ✅ Database schema ready
2. ✅ RLS policies active
3. ✅ Ready to test app

Then we can continue building features!

