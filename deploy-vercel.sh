#!/bin/bash
# Quick Vercel Deployment Script

echo "🚀 Deploying Infinite Player to Vercel..."
echo ""

cd app

# Check if logged in
if ! vercel whoami &> /dev/null; then
    echo "🔐 Please login to Vercel..."
    vercel login
fi

echo "📦 Deploying..."
vercel

echo ""
echo "✅ Deployment started!"
echo ""
echo "📝 Next steps:"
echo "1. Add environment variables in Vercel Dashboard:"
echo "   - NEXT_PUBLIC_SUPABASE_URL"
echo "   - NEXT_PUBLIC_SUPABASE_ANON_KEY"
echo "   - SUPABASE_SERVICE_ROLE_KEY"
echo ""
echo "2. Or add via CLI:"
echo "   vercel env add NEXT_PUBLIC_SUPABASE_URL"
echo "   vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY"
echo "   vercel env add SUPABASE_SERVICE_ROLE_KEY"
echo ""

