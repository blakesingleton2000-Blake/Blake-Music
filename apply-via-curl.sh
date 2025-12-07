#!/bin/bash
# Apply migrations via curl to Supabase REST API

PROJECT_REF="djszkpgtwhdjhexnjdof"
SERVICE_ROLE_KEY="sb_secret_Nfa9TqrXPq6v-nKqb19nFg_B3FukR8X"
SQL_FILE="combined-migration.sql"

echo "🚀 Applying migrations via Supabase API..."

# Read SQL file
SQL=$(cat "$SQL_FILE")

# Execute via Supabase REST API
curl -X POST \
  "https://${PROJECT_REF}.supabase.co/rest/v1/rpc/exec_sql" \
  -H "apikey: ${SERVICE_ROLE_KEY}" \
  -H "Authorization: Bearer ${SERVICE_ROLE_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"query\": $(echo "$SQL" | jq -Rs .)}" \
  2>&1

echo ""
echo "✅ Done!"

