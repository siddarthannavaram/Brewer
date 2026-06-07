#!/bin/bash
# deploy.sh — deploys the latest code from GitHub to web01
# run this from web01 after pulling changes
# usage: ./scripts/deploy.sh

set -e

APP_DIR="/opt/brewer"
SERVICE_NAME="brewer"

echo "========================================"
echo " Brewer Deployment Script"
echo "========================================"

# record current version for rollback
CURRENT_TAG=$(git -C $APP_DIR describe --tags --abbrev=0 2>/dev/null || echo "none")
echo "Current version: $CURRENT_TAG"

# pull latest code
echo "Pulling latest code from GitHub..."
cd $APP_DIR
git pull origin main

# install dependencies
echo "Installing dependencies..."
cd $APP_DIR/app
npm install --omit=dev

# restart the service
echo "Restarting brewer service..."
sudo systemctl restart $SERVICE_NAME

# wait for app to start
echo "Waiting for app to start..."
sleep 5

# health check
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/health)

if [ "$STATUS" = "200" ]; then
  echo "Deployment successful. App is healthy."
  echo "========================================"
else
  echo "Deployment failed. Health check returned HTTP $STATUS"
  echo "Rolling back to $CURRENT_TAG..."
  ./scripts/rollback.sh $CURRENT_TAG
fi
