#!/bin/bash

# Debug script for Docker deployment
echo "=== Docker Build and Debug Script ==="

# Build the image
echo "Building Docker image..."
docker build -t tailwind-app .

if [ $? -eq 0 ]; then
    echo "✅ Docker build successful"
else
    echo "❌ Docker build failed"
    exit 1
fi

# Run the container
echo "Starting container..."
docker run -d -p 3000:80 --name tailwind-app-test tailwind-app

if [ $? -eq 0 ]; then
    echo "✅ Container started successfully"
    echo "🌐 Application should be available at: http://localhost:3000"
else
    echo "❌ Failed to start container"
    exit 1
fi

# Wait a moment for container to start
sleep 3

# Test the endpoints
echo ""
echo "=== Testing endpoints ==="

echo "Testing main page..."
curl -s -o /dev/null -w "Status: %{http_code}\n" http://localhost:3000/

echo "Testing health check..."
curl -s -o /dev/null -w "Status: %{http_code}\n" http://localhost:3000/health

echo "Testing hero image..."
curl -s -o /dev/null -w "Status: %{http_code}\n" http://localhost:3000/assets/images/hero.jpg

echo "Testing CSS file..."
curl -s -o /dev/null -w "Status: %{http_code}\n" http://localhost:3000/dist/output.css

# Show container logs
echo ""
echo "=== Container logs ==="
docker logs tailwind-app-test

# Show what files are actually in the container
echo ""
echo "=== Files in container ==="
docker exec tailwind-app-test find /usr/share/nginx/html -type f

echo ""
echo "=== Cleanup ==="
echo "To stop and remove the test container, run:"
echo "docker stop tailwind-app-test && docker rm tailwind-app-test"
