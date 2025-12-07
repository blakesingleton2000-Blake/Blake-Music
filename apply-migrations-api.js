// Apply migrations via Supabase REST API
// Run: node apply-migrations-api.js

const fs = require('fs');
const https = require('https');

const PROJECT_REF = 'djszkpgtwhdjhexnjdof';
const SUPABASE_URL = `https://${PROJECT_REF}.supabase.co`;

// Read combined migration SQL
const sql = fs.readFileSync('combined-migration.sql', 'utf8');

// Get service role key from environment or prompt
const SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!SERVICE_ROLE_KEY) {
  console.error('❌ SUPABASE_SERVICE_ROLE_KEY not found');
  console.error('   Set it: export SUPABASE_SERVICE_ROLE_KEY=your_key');
  console.error('   Or add to .env.local and source it');
  process.exit(1);
}

// Execute SQL via REST API
const options = {
  hostname: `${PROJECT_REF}.supabase.co`,
  path: '/rest/v1/rpc/exec_sql',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'apikey': SERVICE_ROLE_KEY,
    'Authorization': `Bearer ${SERVICE_ROLE_KEY}`,
  },
};

console.log('🚀 Applying migrations via API...');

const req = https.request(options, (res) => {
  let data = '';
  
  res.on('data', (chunk) => {
    data += chunk;
  });
  
  res.on('end', () => {
    if (res.statusCode === 200 || res.statusCode === 201) {
      console.log('✅ Migrations applied successfully!');
      console.log('Response:', data);
    } else {
      console.error('❌ Error:', res.statusCode);
      console.error('Response:', data);
      console.error('\n⚠️  API method may not be available.');
      console.error('   Please use Supabase SQL Editor instead:');
      console.error(`   https://${PROJECT_REF}.supabase.co`);
      console.error('   1. Go to SQL Editor');
      console.error('   2. Open combined-migration.sql');
      console.error('   3. Copy all contents');
      console.error('   4. Paste and Run');
    }
  });
});

req.on('error', (error) => {
  console.error('❌ Request error:', error.message);
  console.error('\n⚠️  Please use Supabase SQL Editor instead.');
});

req.write(JSON.stringify({ sql }));
req.end();

