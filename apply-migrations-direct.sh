#!/bin/bash
# Direct migration application using Supabase API

set -e

PROJECT_REF="djszkpgtwhdjhexnjdof"
SUPABASE_URL="https://${PROJECT_REF}.supabase.co"

echo "🚀 Applying migrations directly..."

# Check if we have service role key
if [ -z "$SUPABASE_SERVICE_ROLE_KEY" ]; then
    echo "⚠️  SUPABASE_SERVICE_ROLE_KEY not set"
    echo "   Using Supabase CLI instead..."
    
    # Try CLI approach
    cd supabase
    
    # Check if linked
    if [ ! -f ".temp/project-ref" ]; then
        echo "❌ Project not linked. Please run:"
        echo "   supabase login"
        echo "   supabase link --project-ref $PROJECT_REF"
        exit 1
    fi
    
    echo "✅ Project linked, applying migrations..."
    supabase db push
    
else
    echo "✅ Using service role key for direct API access"
    
    # Apply via API (would need REST API endpoint)
    echo "⚠️  Direct API migration not available"
    echo "   Please use Supabase CLI or Dashboard"
fi

