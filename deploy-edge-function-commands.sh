#!/bin/bash
# Commands to deploy Edge Function - Run these manually

echo "🚀 Deploying Edge Function"
echo "=========================="
echo ""
echo "Step 1: Login to Supabase"
echo "Run: supabase login"
echo "(This will open your browser)"
echo ""
read -p "Press Enter after you've logged in..."

echo ""
echo "Step 2: Link to project"
echo "Run: supabase link --project-ref djszkpgtwhdjhexnjdof"
echo ""
read -p "Press Enter after linking..."

echo ""
echo "Step 3: Deploy function"
cd supabase
supabase functions deploy reset-daily-count --no-verify-jwt

echo ""
echo "✅ Function deployed!"
echo ""
echo "Step 4: Set up cron job in Supabase Dashboard"
echo "See DEPLOY_EDGE_FUNCTION_MANUAL.md for cron setup"
