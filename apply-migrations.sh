#!/bin/bash
# Script to apply Supabase migrations
# Usage: ./apply-migrations.sh

echo "🚀 Applying Supabase Migrations..."
echo ""

# Check if supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI not found. Please install it first:"
    echo "   brew install supabase/tap/supabase"
    exit 1
fi

# Check if logged in
echo "📋 Checking Supabase login status..."
if ! supabase projects list &> /dev/null; then
    echo "🔐 Please login to Supabase first..."
    supabase login
fi

# Link to project
echo "🔗 Linking to project djszkpgtwhdjhexnjdof..."
supabase link --project-ref djszkpgtwhdjhexnjdof

# Apply migrations
echo "📦 Applying migrations..."
supabase db push

echo ""
echo "✅ Migrations applied successfully!"
echo ""
echo "📊 Verify tables were created:"
echo "   Go to: https://djszkpgtwhdjhexnjdof.supabase.co"
echo "   Navigate to: Table Editor"
echo ""

