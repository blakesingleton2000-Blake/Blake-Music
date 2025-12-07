#!/bin/bash

# Apply Supabase Migrations via CLI
# This script will apply all migrations and set up storage

set -e

echo "🚀 Starting Supabase Migration Process..."
echo ""

# Check if Supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI not found. Please install it first:"
    echo "   npm install -g supabase"
    echo "   OR"
    echo "   brew install supabase/tap/supabase"
    exit 1
fi

echo "✅ Supabase CLI found"
echo ""

# Check if logged in
echo "📋 Checking Supabase login status..."
if ! supabase projects list &> /dev/null; then
    echo "⚠️  Not logged in. Please login:"
    echo "   supabase login"
    echo ""
    echo "This will open your browser to authenticate."
    read -p "Press Enter after you've logged in..."
fi

echo "✅ Logged in"
echo ""

# Link to project
echo "🔗 Linking to project..."
PROJECT_REF="djszkpgtwhdjhexnjdof"

if ! supabase link --project-ref "$PROJECT_REF" 2>/dev/null; then
    echo "⚠️  Project may already be linked, or you need to provide database password."
    echo "   If prompted, enter your database password from Supabase Dashboard"
    echo "   (Settings → Database → Database password)"
    read -p "Press Enter to continue..."
    supabase link --project-ref "$PROJECT_REF"
fi

echo "✅ Project linked"
echo ""

# Apply migrations
echo "📦 Applying migrations..."
cd supabase

echo ""
echo "1️⃣  Applying main schema migration..."
supabase db execute --file migrations/20250107000000_initial_schema.sql || {
    echo "⚠️  Error applying main schema. Trying alternative method..."
    cat migrations/20250107000000_initial_schema.sql | supabase db execute
}

echo ""
echo "2️⃣  Applying recommendations function..."
supabase db execute --file migrations/20250107000001_recommendations_function.sql || {
    echo "⚠️  Error applying function. Trying alternative method..."
    cat migrations/20250107000001_recommendations_function.sql | supabase db execute
}

echo ""
echo "3️⃣  Setting up storage bucket..."
supabase db execute --file storage-setup.sql || {
    echo "⚠️  Error setting up storage. Trying alternative method..."
    cat storage-setup.sql | supabase db execute
}

cd ..

echo ""
echo "✅ All migrations applied!"
echo ""

# Verify
echo "🔍 Verifying migrations..."
echo ""

echo "Tables:"
supabase db execute --query "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name;" 2>/dev/null || echo "Could not verify tables"

echo ""
echo "Functions:"
supabase db execute --query "SELECT proname FROM pg_proc WHERE proname LIKE 'match%';" 2>/dev/null || echo "Could not verify functions"

echo ""
echo "Storage bucket:"
supabase db execute --query "SELECT name FROM storage.buckets WHERE id = 'audio';" 2>/dev/null || echo "Could not verify storage"

echo ""
echo "🎉 Migration process complete!"
echo ""
echo "Next steps:"
echo "1. Get API keys (see ENV_TEMPLATE.md)"
echo "2. Set up .env.local file"
echo "3. Test locally: cd app && npm run dev"
