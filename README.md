# Infinite Player - AI Music Generation App

Spotify-like interface for infinite personalized AI-generated music.

## 🚀 Quick Start

### 1. Apply Database Migrations

**Via Supabase Dashboard** (5 minutes):

1. Go to: https://djszkpgtwhdjhexnjdof.supabase.co
2. Click **SQL Editor**
3. Open: `supabase/migrations/20250107000000_initial_schema.sql`
4. Copy ALL contents → Paste in SQL Editor → Run
5. Verify: Check **Table Editor** → Should see 10 tables

See `apply-supabase-migration.md` for detailed steps.

### 2. Deploy to Vercel

**Option A: Via Dashboard** (Recommended)

1. Push to GitHub:
   ```bash
   git remote add origin YOUR_GITHUB_REPO_URL
   git push -u origin main
   ```

2. Go to: https://vercel.com/new
3. Import your GitHub repo
4. **Set Root Directory**: `app`
5. Add environment variables (see below)
6. Deploy

**Option B: Via CLI**

```bash
./deploy-vercel.sh
```

Then add environment variables via Vercel Dashboard or CLI.

### 3. Run Locally

```bash
cd app
npm install
npm run dev
```

Visit: http://localhost:3000

---

## 📁 Project Structure

```
Music/
├── app/                    # Next.js app (deploy this to Vercel)
│   ├── app/               # App Router pages
│   ├── lib/               # Utilities (Supabase clients)
│   └── components/        # React components (to be created)
├── supabase/
│   ├── migrations/        # Database migrations
│   └── functions/         # Edge Functions
└── docs/                  # Documentation
```

---

## 🔑 Environment Variables

**Required for Supabase**:
- `NEXT_PUBLIC_SUPABASE_URL` - Already set
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` - Already set
- `SUPABASE_SERVICE_ROLE_KEY` - Already set

**To Add Later**:
- `OPENAI_API_KEY` - For LLM features
- `RUNPOD_API_KEY` - For MusicGen generation
- `STRIPE_SECRET_KEY` - For payments

See `.env.example` in `app/` directory.

---

## 📚 Documentation

- `SETUP_COMPLETE.md` - Complete setup guide
- `database-architecture.md` - Database schema docs
- `VERCEL_DEPLOYMENT.md` - Deployment instructions
- `DEPLOY_NOW.md` - Quick deployment guide

---

## 🎨 Tech Stack

- **Frontend**: Next.js 16, React, TypeScript, Tailwind CSS
- **Backend**: Vercel Serverless Functions
- **Database**: Supabase (PostgreSQL + pgvector)
- **Auth**: Supabase Auth
- **State**: Zustand, React Query
- **Animations**: Framer Motion
- **AI**: MusicGen (RunPod), OpenAI

---

## 🚧 Current Status

- ✅ Database schema created
- ✅ Next.js app initialized
- ✅ Supabase integration configured
- ✅ Vercel deployment ready
- 🔄 Features in progress...

---

## 📝 Next Steps

1. Apply Supabase migrations
2. Deploy to Vercel
3. Build onboarding flow
4. Create API routes
5. Build UI components

---

## 🤝 Contributing

This is a private project. See PRDs for feature specifications.

---

## 📄 License

Private - All rights reserved

