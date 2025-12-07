# Apply Migrations via Supabase CLI

## Prerequisites

1. Install Supabase CLI:
   ```bash
   npm install -g supabase
   # OR
   brew install supabase/tap/supabase
   ```

2. Verify installation:
   ```bash
   supabase --version
   ```

## Step-by-Step

### Step 1: Login to Supabase

```bash
supabase login
```

This will open your browser to authenticate.

### Step 2: Link to Your Project

```bash
supabase link --project-ref djszkpgtwhdjhexnjdof
```

You'll be prompted for your database password (found in Supabase Dashboard → Settings → Database).

### Step 3: Apply Migrations

```bash
cd supabase
supabase db push
```

This will apply all migrations in the `migrations/` folder.

### Step 4: Verify Migrations

```bash
supabase db diff
```

Should show no differences if migrations applied successfully.

### Step 5: Set Up Storage Bucket

Run the storage setup SQL:

```bash
supabase db execute --file storage-setup.sql
```

Or manually:

```bash
supabase db execute
# Then paste the contents of storage-setup.sql
```

## Alternative: Apply Migrations Individually

If `db push` doesn't work, you can apply migrations individually:

```bash
# Apply main schema
supabase db execute --file migrations/20250107000000_initial_schema.sql

# Apply recommendations function
supabase db execute --file migrations/20250107000001_recommendations_function.sql

# Apply storage setup
supabase db execute --file storage-setup.sql
```

## Verify Everything Worked

```bash
# Check tables
supabase db execute --query "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name;"

# Check functions
supabase db execute --query "SELECT proname FROM pg_proc WHERE proname LIKE 'match%';"

# Check storage bucket
supabase db execute --query "SELECT name FROM storage.buckets WHERE id = 'audio';"
```

## Troubleshooting

### Error: "Not logged in"
```bash
supabase login
```

### Error: "Project not linked"
```bash
supabase link --project-ref djszkpgtwhdjhexnjdof
```

### Error: "Migration already applied"
This is fine - migrations use `IF NOT EXISTS` so they're safe to run multiple times.

### Error: "Permission denied"
Make sure you're using the correct database password from Supabase Dashboard.

