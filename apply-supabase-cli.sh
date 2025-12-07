#!/bin/bash
# Apply Supabase Migrations via CLI
# Run this script in your terminal (not via AI)

echo "🚀 Applying Supabase Migrations via CLI..."
echo ""

# Check if supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI not found. Install it:"
    echo "   brew install supabase/tap/supabase"
    exit 1
fi

# Login (will open browser)
echo "🔐 Logging in to Supabase..."
echo "   (This will open your browser)"
supabase login

# Link to project
echo ""
echo "🔗 Linking to project djszkpgtwhdjhexnjdof..."
supabase link --project-ref djszkpgtwhdjhexnjdof

# Apply migrations
echo ""
echo "📦 Applying migrations..."
supabase db push

echo ""
echo "✅ Migrations applied!"
echo ""
echo "📊 Verify in Supabase Dashboard:"
echo "   https://djszkpgtwhdjhexnjdof.supabase.co"
echo "   Go to: Table Editor → Should see 10 tables"
echo ""

