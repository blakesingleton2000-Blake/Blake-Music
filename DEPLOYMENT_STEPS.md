# Deployment Steps - Run These Commands

## Step 1: Apply Supabase Migrations via CLI

Run this in your terminal:

```bash
cd /Users/blakesingleton/Desktop/Music

# Option A: Use the script
./apply-supabase-cli.sh

# Option B: Run commands manually
supabase login                    # Will open browser for auth
supabase link --project-ref djszkpgtwhdjhexnjdof
supabase db push
```

**Verify**: Go to https://djszkpgtwhdjhexnjdof.supabase.co → Table Editor → Should see 10 tables ✅

---

## Step 2: Push to GitHub

Run these commands in your terminal:

```bash
cd /Users/blakesingleton/Desktop/Music

# Check if remote is set
git remote -v

# If not set, add remote:
git remote add origin https://github.com/blakesingleton2000-Blake/Blake-Music.git

# Push to GitHub (will prompt for GitHub credentials)
git push -u origin main
```

**Note**: If you get authentication errors, you may need to:
- Use GitHub Personal Access Token instead of password
- Or set up SSH keys: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

**Alternative**: Use GitHub Desktop or VS Code's Git integration to push.

---

## Step 3: Connect Vercel to GitHub

1. **Go to Vercel**: https://vercel.com/new
2. **Click**: "Import Git Repository"
3. **Select**: `blakesingleton2000-Blake/Blake-Music`
4. **Configure**:
   - **Framework Preset**: Next.js (auto-detected)
   - **Root Directory**: `app` ⚠️ **IMPORTANT!**
   - **Build Command**: `npm run build` (auto)
   - **Output Directory**: `.next` (auto)
   - **Install Command**: `npm install` (auto)
5. **Click**: "Deploy"

---

## Step 4: Add Environment Variables in Vercel

After first deployment:

1. Go to your Vercel project → **Settings** → **Environment Variables**
2. Add these 3 variables (for Production, Preview, Development):

   ```
   NEXT_PUBLIC_SUPABASE_URL=https://djszkpgtwhdjhexnjdof.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=sb_publishable_cK8kjrpekz2ssEwQOBvbtw_yxM37UGQ
   SUPABASE_SERVICE_ROLE_KEY=sb_secret_Nfa9TqrXPq6v-nKqb19nFg_B3FukR8X
   ```

3. Click **Save**
4. Go to **Deployments** → Click **Redeploy** on latest deployment

---

## Step 5: Verify Everything Works

1. **Supabase**: Check Table Editor → 10 tables exist ✅
2. **GitHub**: Check repo → Code is pushed ✅
3. **Vercel**: Visit deployment URL → App loads ✅
4. **Browser Console**: No Supabase connection errors ✅

---

## ✅ You're Deployed!

Once all steps are complete:
- ✅ Database migrations applied
- ✅ Code pushed to GitHub
- ✅ Vercel deployment live
- ✅ Environment variables configured

**Next**: We'll continue building features! 🚀

