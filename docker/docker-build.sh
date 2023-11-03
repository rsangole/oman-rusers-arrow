#!/usr/bin/env bash

DOCKER_NAME=hatmatrix/omanrusers-arrow:v1.0.0

# platform='linux/amd64' is required for M1 Macs
docker build --tag $DOCKER_NAME . --platform='linux/amd64'

if [[ $? = 0 ]]; then
  echo "Pushing docker image..."
  docker push $DOCKER_NAME
else
  echo "Docker build failed"
fi
