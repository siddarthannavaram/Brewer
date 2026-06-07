#!/bin/bash
# rollback.sh — rolls back to a specific git tag
# usage: ./scripts/rollback.sh v1.0.0

set -e

if [ -z "$1" ]; then
  echo "Usage: ./scripts/rollback.sh <version-tag>"
  echo "Example: ./scripts/rollback.sh v1.0.0"
  echo ""
  echo "Available tags:"
  git tag
  exit 1
fi

VERSION=$1
APP_DIR="/opt/brewer"
SERVICE_NAME="brewer"

echo "========================================"
echo " Brewer Rollback to $VERSION"
echo "========================================"

cd $APP_DIR

# fetch latest tags
git fetch --tags

# checkout the specific version
echo "Checking out $VERSION..."
git checkout $VERSION

# install dependencies for this version
echo "Installing dependencies..."
cd $APP_DIR/app
npm install --omit=dev

# restart service
echo "Restarting brewer service..."
sudo systemctl restart $SERVICE_NAME

sleep 5

# verify health
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/health)

if [ "$STATUS" = "200" ]; then
  echo "Rollback to $VERSION successful. App is healthy."
  echo "========================================"
else
  echo "Rollback failed. App is not responding."
  echo "Check logs: sudo journalctl -u brewer -n 50"
  exit 1
fi
