#!/bin/bash
# Deploy Daily Counter Reset Edge Function to Supabase

set -e

echo "🚀 Deploying Daily Counter Reset Edge Function"
echo "================================================"
echo ""

# Check if supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI not found. Install with: npm install -g supabase"
    exit 1
fi

# Check if logged in
if ! supabase projects list &> /dev/null; then
    echo "⚠️  Not logged in to Supabase. Logging in..."
    supabase login
fi

# Navigate to supabase directory
cd "$(dirname "$0")/supabase"

# Check if project is linked
if [ ! -f ".supabase/config.toml" ]; then
    echo "⚠️  Project not linked. Linking now..."
    echo "Project ref: djszkpgtwhdjhexnjdof"
    supabase link --project-ref djszkpgtwhdjhexnjdof
fi

echo ""
echo "📦 Deploying reset-daily-count function..."
echo ""

# Deploy the function
supabase functions deploy reset-daily-count --no-verify-jwt

echo ""
echo "✅ Edge Function deployed successfully!"
echo ""
echo "📋 Next steps:"
echo "  1. Go to Supabase Dashboard → Database → Cron Jobs"
echo "  2. Click 'New Cron Job'"
echo "  3. Schedule: 0 0 * * * (midnight UTC daily)"
echo "  4. SQL:"
echo ""
echo "SELECT net.http_post("
echo "  url := 'https://djszkpgtwhdjhexnjdof.supabase.co/functions/v1/reset-daily-count',"
echo "  headers := '{\"Authorization\": \"Bearer YOUR_SERVICE_ROLE_KEY\"}'::jsonb"
echo ");"
echo ""
echo "Replace YOUR_SERVICE_ROLE_KEY with your actual service role key"
echo ""
