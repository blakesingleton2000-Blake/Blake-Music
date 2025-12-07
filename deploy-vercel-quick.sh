#!/bin/bash
# Quick Vercel Deployment

set -e

echo "🚀 Deploying to Vercel..."
echo ""

cd app

# Check if vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "📦 Installing Vercel CLI..."
    npm install -g vercel
fi

# Check if logged in
if ! vercel whoami &> /dev/null; then
    echo "🔐 Please login to Vercel..."
    vercel login
fi

echo "✅ Logged in to Vercel"
echo ""

# Deploy
echo "📦 Deploying..."
vercel --prod

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📋 Next steps:"
echo "1. Add environment variables in Vercel Dashboard"
echo "2. Set root directory to 'app' if not auto-detected"
echo "3. Test your live URL!"

