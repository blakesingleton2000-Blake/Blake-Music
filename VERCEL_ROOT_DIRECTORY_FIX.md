# 🔧 Fix Vercel Root Directory Issue

## ❌ Current Error

```
npm error path /vercel/path0/package.json
npm error enoent Could not read package.json
```

**Problem**: Vercel is looking for `package.json` in the root directory, but it's in the `app/` directory.

## ✅ Solution: Set Root Directory in Vercel Dashboard

### Step-by-Step Instructions

1. **Go to Vercel Dashboard**
   - Visit: https://vercel.com/dashboard
   - Login if needed

2. **Select Your Project**
   - Click on: **Blake-Music** (or your project name)

3. **Go to Settings**
   - Click: **Settings** tab (top navigation)
   - Click: **General** (left sidebar)

4. **Set Root Directory**
   - Scroll down to: **Root Directory** section
   - You'll see a field (probably empty or set to `.`)
   - **Change it to**: `app`
   - Click: **Save**

5. **Redeploy**
   - Go to: **Deployments** tab
   - Find the latest deployment
   - Click: **⋯** (three dots) → **Redeploy**
   - Or: Click **Redeploy** button

6. **Wait for Build**
   - Build should now succeed!
   - Vercel will run commands from `app/` directory
   - `package.json` will be found correctly

## 📸 Visual Guide

```
Vercel Dashboard
├── Your Project (Blake-Music)
│   ├── Settings
│   │   ├── General
│   │   │   └── Root Directory: [app] ← Set this!
│   │   └── Environment Variables
│   └── Deployments
│       └── [Latest] → Redeploy
```

## ✅ What This Does

When Root Directory is set to `app`:
- ✅ Vercel changes working directory to `app/` before running commands
- ✅ `npm install` finds `app/package.json`
- ✅ `npm run build` runs from `app/` directory
- ✅ Next.js is detected correctly
- ✅ Build succeeds!

## 🔍 Verify It's Set

After saving, check:
- Root Directory field shows: `app`
- Next deployment should succeed
- Build logs should show: `Running "install" command: npm install` (from app directory)

## ⚠️ Important Notes

- **Root Directory** is a project setting, not in `vercel.json`
- Must be set in Vercel Dashboard → Settings → General
- Takes effect on next deployment
- You may need to manually redeploy after changing it

---

**Once Root Directory is set to `app`, your build will succeed!** 🚀

