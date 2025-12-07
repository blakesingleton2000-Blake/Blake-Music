#!/bin/bash
# Deploy Supabase Edge Function

set -e

echo "🚀 Deploying Edge Function..."
echo ""

# Check if logged in
if ! supabase projects list &> /dev/null; then
    echo "⚠️  Not logged in. Please login first:"
    echo "   supabase login"
    exit 1
fi

cd supabase

echo "📦 Deploying reset-daily-count function..."
supabase functions deploy reset-daily-count

echo ""
echo "✅ Edge Function deployed!"
echo ""
echo "📋 Next: Set up cron job"
echo ""
echo "1. Go to: https://djszkpgtwhdjhexnjdof.supabase.co"
echo "2. Database → Cron Jobs (or Extensions → pg_cron)"
echo "3. Create cron job:"
echo "   - Schedule: 0 0 * * * (midnight UTC)"
echo "   - SQL:"
echo "     SELECT net.http_post("
echo "       url := 'https://djszkpgtwhdjhexnjdof.supabase.co/functions/v1/reset-daily-count',"
echo "       headers := '{\"Authorization\": \"Bearer YOUR_SERVICE_ROLE_KEY\"}'::jsonb"
echo "     );"
echo ""
echo "✅ Done!"

