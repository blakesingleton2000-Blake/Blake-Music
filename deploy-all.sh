#!/bin/bash
# Complete Deployment Script for Infinite Player
# Run this after setting up all environment variables

set -e  # Exit on error

echo "🚀 Infinite Player - Complete Deployment"
echo "========================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check prerequisites
echo "📋 Checking prerequisites..."

if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed${NC}"
    exit 1
fi

if ! command -v supabase &> /dev/null; then
    echo -e "${RED}❌ Supabase CLI is not installed${NC}"
    echo "Install: npm install -g supabase"
    exit 1
fi

if ! command -v vercel &> /dev/null; then
    echo -e "${RED}❌ Vercel CLI is not installed${NC}"
    echo "Install: npm install -g vercel"
    exit 1
fi

echo -e "${GREEN}✅ All prerequisites met${NC}"
echo ""

# Step 1: Build RunPod Docker image
echo "📦 Step 1: Building RunPod Docker image..."
cd runpod

if [ -z "$DOCKER_USERNAME" ]; then
    echo -e "${YELLOW}⚠️  DOCKER_USERNAME not set. Please set it:${NC}"
    echo "export DOCKER_USERNAME=your_dockerhub_username"
    exit 1
fi

docker build -t infinite-musicgen:latest .
docker tag infinite-musicgen:latest "$DOCKER_USERNAME/infinite-musicgen:latest"

echo -e "${GREEN}✅ Docker image built${NC}"
echo ""

# Step 2: Push to Docker Hub
echo "📤 Step 2: Pushing to Docker Hub..."
read -p "Push to Docker Hub? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker push "$DOCKER_USERNAME/infinite-musicgen:latest"
    echo -e "${GREEN}✅ Pushed to Docker Hub${NC}"
else
    echo -e "${YELLOW}⚠️  Skipped Docker Hub push${NC}"
fi
echo ""

# Step 3: Deploy Edge Function
echo "🔧 Step 3: Deploying Supabase Edge Function..."
cd ../supabase
supabase functions deploy reset-daily-count --no-verify-jwt
echo -e "${GREEN}✅ Edge Function deployed${NC}"
echo ""

# Step 4: Deploy to Vercel
echo "🚀 Step 4: Deploying to Vercel..."
cd ../app
read -p "Deploy to production? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    vercel --prod
    echo -e "${GREEN}✅ Deployed to Vercel${NC}"
else
    echo -e "${YELLOW}⚠️  Skipped Vercel deployment${NC}"
fi
echo ""

# Summary
echo "========================================"
echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo ""
echo "📋 Next Steps:"
echo "1. Create RunPod endpoint using image: $DOCKER_USERNAME/infinite-musicgen:latest"
echo "2. Add RUNPOD_API_KEY and RUNPOD_ENDPOINT_ID to Vercel"
echo "3. Apply Supabase migrations (see QUICK_START_DEPLOY.md)"
echo "4. Create storage bucket 'audio' in Supabase"
echo "5. Set up cron job for reset-daily-count function"
echo ""
echo "See QUICK_START_DEPLOY.md for detailed instructions."
