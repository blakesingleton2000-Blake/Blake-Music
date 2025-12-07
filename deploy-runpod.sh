#!/bin/bash
# Deploy RunPod Serverless Template

set -e

echo "🚀 Deploying RunPod Serverless Template..."
echo ""

# Check Docker
if ! docker info &> /dev/null; then
    echo "❌ Docker daemon is not running"
    echo "   Please start Docker Desktop and try again"
    exit 1
fi

cd runpod

echo "📦 Building Docker image..."
docker build -t musicgen-runpod:latest .

echo ""
echo "✅ Docker image built successfully!"
echo ""
echo "📋 Next steps:"
echo ""
echo "1. Tag image for your registry:"
echo "   docker tag musicgen-runpod:latest YOUR_USERNAME/musicgen-runpod:latest"
echo ""
echo "2. Login to Docker Hub:"
echo "   docker login"
echo ""
echo "3. Push image:"
echo "   docker push YOUR_USERNAME/musicgen-runpod:latest"
echo ""
echo "4. Create RunPod endpoint:"
echo "   - Go to: https://www.runpod.io/"
echo "   - Serverless → Templates → Create Template"
echo "   - Container: YOUR_USERNAME/musicgen-runpod:latest"
echo "   - GPU: A100 Spot"
echo "   - Create Template → Create Endpoint"
echo "   - Get Endpoint ID and API Key"
echo ""
echo "5. Add to app/.env.local:"
echo "   RUNPOD_API_KEY=your_key"
echo "   RUNPOD_ENDPOINT_ID=your_endpoint_id"

