# 🚀 Run These Commands Now

Open your terminal and run these commands **one at a time**:

## Step 1: Login to Supabase

```bash
cd /Users/blakesingleton/Desktop/Music
supabase login
```

This will open your browser. Complete the authentication, then come back to terminal.

---

## Step 2: Link to Your Project

```bash
supabase link --project-ref djszkpgtwhdjhexnjdof
```

When prompted, enter your **database password** from:
- Supabase Dashboard → Settings → Database → Database password

---

## Step 3: Apply Migrations

```bash
cd supabase

# Apply main schema (creates all 10 tables)
supabase db execute --file migrations/20250107000000_initial_schema.sql

# Apply recommendations function
supabase db execute --file migrations/20250107000001_recommendations_function.sql

# Set up storage bucket
supabase db execute --file storage-setup.sql

cd ..
```

---

## Step 4: Verify Everything Worked

```bash
# Check tables (should show 10 tables)
supabase db execute --query "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name;"

# Check functions (should show 2 functions)
supabase db execute --query "SELECT proname FROM pg_proc WHERE proname LIKE 'match%';"

# Check storage (should show audio bucket)
supabase db execute --query "SELECT name FROM storage.buckets WHERE id = 'audio';"
```

---

## ✅ Success!

If you see:
- ✅ 10 tables listed
- ✅ 2 functions (match_tracks, match_embeddings)
- ✅ 1 storage bucket (audio)

**You're done!** 🎉

---

## Next Steps

1. **Test the app locally**:
   ```bash
   cd app
   npm install
   npm run dev
   ```

2. **Get API keys** (see `ENV_TEMPLATE.md`)

3. **Deploy RunPod** (see `runpod/README.md`)

---

## 🆘 Troubleshooting

### "Not logged in"
- Run `supabase login` again
- Make sure browser authentication completed

### "Project not linked"
- Run `supabase link --project-ref djszkpgtwhdjhexnjdof` again
- Make sure you enter the correct database password

### "Permission denied"
- Check database password in Supabase Dashboard
- Make sure you're the project owner

### "File not found"
- Make sure you're in the `/Users/blakesingleton/Desktop/Music` directory
- Check that migration files exist: `ls supabase/migrations/`

---

**Copy and paste these commands into your terminal now!** 🚀

