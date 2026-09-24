#!/bin/bash

set -e

APP_NAME="zero-downtime-app"
CONTAINER_NAME="${CONTAINER_NAME:-app1}"
VERSION="${VERSION:-latest}"
SERVER="${SERVER:-aws-server}"

echo "======================================"
echo "Starting AWS deployment"
echo "Version: $VERSION"
echo "Server: $SERVER"
echo "======================================"

cd /home/ec2-user/zero-downtime-deployment

echo "Updating source code..."
git pull origin main

echo "Saving current image for rollback..."

if docker image inspect ${APP_NAME}:current >/dev/null 2>&1; then
    docker tag ${APP_NAME}:current ${APP_NAME}:previous
elif docker image inspect ${APP_NAME}:latest >/dev/null 2>&1; then
    docker tag ${APP_NAME}:latest ${APP_NAME}:previous
elif docker image inspect ${APP_NAME} >/dev/null 2>&1; then
    docker tag ${APP_NAME} ${APP_NAME}:previous
fi

echo "Building new Docker image..."

docker build -t ${APP_NAME}:current -f app/Dockerfile .

echo "Stopping old container..."

docker rm -f ${CONTAINER_NAME} 2>/dev/null || true

echo "Starting new container..."

docker run -d \
  --name ${CONTAINER_NAME} \
  -p 5000:5000 \
  -e VERSION="${VERSION}" \
  -e SERVER="${SERVER}" \
  ${APP_NAME}:current

echo "Waiting for application..."

sleep 10

echo "Running health check..."

if curl -f http://localhost:5000/health; then
    echo ""
    echo "======================================"
    echo "DEPLOYMENT SUCCESSFUL"
    echo "Version: $VERSION"
    echo "Server: $SERVER"
    echo "======================================"
else
    echo ""
    echo "HEALTH CHECK FAILED"
    echo "Starting automatic rollback..."

    docker rm -f ${CONTAINER_NAME} 2>/dev/null || true

    if docker image inspect ${APP_NAME}:previous >/dev/null 2>&1; then
        docker run -d \
          --name ${CONTAINER_NAME} \
          -p 5000:5000 \
          -e VERSION="previous" \
          -e SERVER="${SERVER}" \
          ${APP_NAME}:previous
    else
        echo "No previous image available for rollback."
        exit 1
    fi

    sleep 5

    if curl -f http://localhost:5000/health; then
        echo "ROLLBACK SUCCESSFUL"
    else
        echo "ROLLBACK FAILED"
        exit 1
    fi

    exit 1
fi