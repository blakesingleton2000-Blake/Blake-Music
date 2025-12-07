#!/bin/bash

# Test RunPod API Connection
# Usage: ./test-runpod.sh

ENDPOINT_ID="60f1l3y3ck0sp2"
API_KEY="YOUR_RUNPOD_API_KEY"
API_URL="https://api.runpod.io/v2"

echo "🧪 Testing RunPod API Connection..."
echo ""
echo "Endpoint ID: $ENDPOINT_ID"
echo "API URL: $API_URL"
echo ""

# Test 1: Create a job
echo "📤 Creating test job..."
RESPONSE=$(curl -s -X POST "$API_URL/$ENDPOINT_ID/run" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "input": {
      "prompt": "test music generation",
      "duration_seconds": 30,
      "mode": "new"
    }
  }')

echo "Response: $RESPONSE"
echo ""

# Extract job ID
JOB_ID=$(echo $RESPONSE | grep -o '"id":"[^"]*' | cut -d'"' -f4)

if [ -z "$JOB_ID" ]; then
  echo "❌ Failed to get job ID. Check your API key and endpoint ID."
  exit 1
fi

echo "✅ Job created: $JOB_ID"
echo ""

# Test 2: Check status
echo "📊 Checking job status..."
STATUS_RESPONSE=$(curl -s "$API_URL/$ENDPOINT_ID/status/$JOB_ID" \
  -H "Authorization: Bearer $API_KEY")

echo "Status: $STATUS_RESPONSE"
echo ""

echo "✅ API connection successful!"
echo ""
echo "Next steps:"
echo "  1. Add API key to app/.env.local"
echo "  2. Add API key to Vercel environment variables"
echo "  3. Deploy handler code to RunPod endpoint"
echo "  4. Test from your app"

