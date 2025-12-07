// Apply migrations directly via Supabase Management API
const https = require('https');
const fs = require('fs');

const PROJECT_REF = 'djszkpgtwhdjhexnjdof';
const SERVICE_ROLE_KEY = 'sb_secret_Nfa9TqrXPq6v-nKqb19nFg_B3FukR8X';
const sql = fs.readFileSync('combined-migration.sql', 'utf8');

// Use Supabase Management API to execute SQL
const options = {
  hostname: `${PROJECT_REF}.supabase.co`,
  path: '/rest/v1/rpc/exec_sql',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'apikey': SERVICE_ROLE_KEY,
    'Authorization': `Bearer ${SERVICE_ROLE_KEY}`,
    'Prefer': 'return=minimal',
  },
};

console.log('🚀 Applying migrations via Supabase API...');

const req = https.request(options, (res) => {
  let data = '';
  res.on('data', (chunk) => data += chunk);
  res.on('end', () => {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      console.log('✅ Migrations applied successfully!');
    } else {
      console.log('⚠️  API response:', res.statusCode);
      console.log('Response:', data);
      console.log('\nTrying alternative method...');
    }
  });
});

req.on('error', (error) => {
  console.error('Error:', error.message);
});

req.write(JSON.stringify({ query: sql }));
req.end();

