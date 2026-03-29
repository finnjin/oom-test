#!/bin/bash
set -e

PROJECT_NAME="OomTest"
CONTAINER_NAME="oom-test"
IMAGE_NAME="oom-test"

echo "=== Building image ==="
docker build --build-arg PROJECT_NAME=$PROJECT_NAME -t $IMAGE_NAME .

echo "=== Running container with 667MB memory limit, which results in *.75 = 500MB for dotnet ==="
docker rm -f $CONTAINER_NAME 2>/dev/null || true
docker run -di --name $CONTAINER_NAME -m=667m $IMAGE_NAME

echo "=== Waiting for app to start ==="
sleep 1
docker logs $CONTAINER_NAME

echo "=== Entering container ==="
docker exec -it $CONTAINER_NAME bash
