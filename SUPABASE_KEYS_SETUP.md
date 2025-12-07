# Your Supabase Keys (Keep This Secure!)

## ✅ Your Keys

From your Supabase dashboard:

```env
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=https://djszkpgtwhdjhexnjdof.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=sb_publishable_cK8kjrpekz2ssEwQOBvbtw_yxM37UGQ
SUPABASE_SERVICE_ROLE_KEY=sb_secret_Nfa9TqrXPq6v-nKqb19nFg_B3FukR8X
```

## 📝 How to Add These to Your Project

### For Local Development (`app/.env.local`):

1. Copy the keys above
2. Add them to `app/.env.local` (create the file if it doesn't exist)
3. Make sure `.env.local` is in `.gitignore` (it should be already)

### For Vercel Production:

1. Go to your Vercel project dashboard
2. Settings → Environment Variables
3. Add each variable:
   - `NEXT_PUBLIC_SUPABASE_URL` = `https://djszkpgtwhdjhexnjdof.supabase.co`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY` = `sb_publishable_cK8kjrpekz2ssEwQOBvbtw_yxM37UGQ`
   - `SUPABASE_SERVICE_ROLE_KEY` = `sb_secret_Nfa9TqrXPq6v-nKqb19nFg_B3FukR8X`
4. Make sure to add them for **Production**, **Preview**, and **Development** environments

### For Supabase Edge Functions:

1. Go to Supabase Dashboard → Edge Functions → Settings
2. Add environment variables:
   - `SUPABASE_URL` = `https://djszkpgtwhdjhexnjdof.supabase.co`
   - `SUPABASE_SERVICE_ROLE_KEY` = `sb_secret_Nfa9TqrXPq6v-nKqb19nFg_B3FukR8X`

## 🔐 Security Notes

- ✅ **Publishable key** (`NEXT_PUBLIC_SUPABASE_ANON_KEY`) is safe to expose in browser
- 🔒 **Secret key** (`SUPABASE_SERVICE_ROLE_KEY`) must NEVER be exposed to client
- ⚠️ **Never commit** these keys to git (already in `.gitignore`)
- 🔄 **Rotate keys** if exposed or compromised

## ✅ Next Steps

1. Add these keys to `app/.env.local` for local testing
2. Add these keys to Vercel for production
3. Test database connection locally
4. Continue with RunPod setup

---

**Note**: The new Supabase keys (`sb_publishable_` and `sb_secret_`) work exactly like the old `anon` and `service_role` keys. The code doesn't need any changes - just use them directly!

