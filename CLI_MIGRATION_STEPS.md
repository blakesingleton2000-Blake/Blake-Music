# Apply Migrations via CLI - Step by Step

## Quick Start

Run these commands in order:

### Step 1: Login to Supabase

```bash
supabase login
```

This will open your browser. Complete the authentication.

### Step 2: Link to Your Project

```bash
supabase link --project-ref djszkpgtwhdjhexnjdof
```

You'll be prompted for your database password. Get it from:
- Supabase Dashboard → Settings → Database → Database password

### Step 3: Apply Migrations

```bash
cd supabase

# Apply main schema
supabase db execute --file migrations/20250107000000_initial_schema.sql

# Apply recommendations function
supabase db execute --file migrations/20250107000001_recommendations_function.sql

# Set up storage
supabase db execute --file storage-setup.sql

cd ..
```

### Step 4: Verify

```bash
# Check tables (should show 10 tables)
supabase db execute --query "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name;"

# Check functions (should show match_tracks and match_embeddings)
supabase db execute --query "SELECT proname FROM pg_proc WHERE proname LIKE 'match%';"

# Check storage (should show audio bucket)
supabase db execute --query "SELECT name FROM storage.buckets WHERE id = 'audio';"
```

## Automated Script

Or run the automated script:

```bash
./apply-migrations-cli.sh
```

This will guide you through each step.

## Troubleshooting

### "Not logged in"
```bash
supabase login
```

### "Project not linked"
```bash
supabase link --project-ref djszkpgtwhdjhexnjdof
```

### "Permission denied"
Make sure you're using the correct database password from Supabase Dashboard.

### Alternative: Use db push
If individual files don't work, try:
```bash
cd supabase
supabase db push
```

