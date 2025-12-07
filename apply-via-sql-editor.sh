#!/bin/bash
# Generate SQL script that can be pasted directly into Supabase SQL Editor

echo "📝 Generating combined migration SQL..."
echo ""
echo "Copy the SQL below and paste it into Supabase SQL Editor:"
echo "https://djszkpgtwhdjhexnjdof.supabase.co"
echo ""
echo "=========================================="
echo ""

cat supabase/migrations/20250107000000_initial_schema.sql
echo ""
echo "-- =========================================="
echo "-- Recommendations Function"
echo "-- =========================================="
echo ""
cat supabase/migrations/20250107000001_recommendations_function.sql
echo ""
echo "-- =========================================="
echo "-- Storage Setup"
echo "-- =========================================="
echo ""
cat supabase/storage-setup.sql

echo ""
echo "=========================================="
echo ""
echo "✅ Copy everything above and paste into Supabase SQL Editor"
echo "   Then click 'Run'"

