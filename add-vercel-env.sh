#!/bin/bash
# Add environment variables to Vercel via CLI

set -e

echo "🚀 Adding Environment Variables to Vercel"
echo "=========================================="
echo ""

# Check if vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "❌ Vercel CLI not found. Install with: npm install -g vercel"
    exit 1
fi

# Check if logged in
if ! vercel whoami &> /dev/null; then
    echo "⚠️  Not logged in to Vercel. Logging in..."
    vercel login
fi

# Navigate to app directory
cd "$(dirname "$0")/app"

# Check if project is linked
if [ ! -f ".vercel/project.json" ]; then
    echo "⚠️  Project not linked. Linking now..."
    echo "Please select your project when prompted, or create a new one."
    vercel link
fi

echo ""
echo "📝 Adding environment variables..."
echo ""

# Read .env.local and add each variable
while IFS='=' read -r key value; do
    # Skip empty lines and comments
    [[ -z "$key" || "$key" =~ ^#.*$ ]] && continue
    
    # Remove quotes from value if present
    value=$(echo "$value" | sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")
    
    # Skip if value is empty or placeholder
    [[ -z "$value" || "$value" =~ ^your_.*$ || "$value" =~ ^sk_test_your.*$ || "$value" =~ ^pk_test_your.*$ ]] && continue
    
    echo "Adding: $key"
    
    # Add to all environments (production, preview, development)
    echo "$value" | vercel env add "$key" production
    echo "$value" | vercel env add "$key" preview
    echo "$value" | vercel env add "$key" development
    
    echo "✅ Added $key"
    echo ""
done < .env.local

echo ""
echo "✅ All environment variables added!"
echo ""
echo "📋 Next steps:"
echo "  1. Redeploy your Vercel project: vercel --prod"
echo "  2. Or trigger a redeploy from Vercel Dashboard"
echo ""

