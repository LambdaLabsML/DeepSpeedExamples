#!/bin/bash

# Check if vm.max_map_count is lower than recommended
max_map_count_val=$(sysctl -n vm.max_map_count)
if [ "$max_map_count_val" -lt 1500000 ]; then
    echo "WARNING: vm.max_map_count is not set to 1500000."
    echo "You may want to run 'make env' if running on a cluster"
fi

# Set DOCKERFILE_PATH based on environment variable, if defined
# else set DOCKERFILE_PATH based on current architecture, if available
# else default to dockerfiles/Dockerfile-A10
if [ -f .env ]; then
  source .env
fi
if [ -z "$DOCKERFILE_PATH" ]; then
  GPU=$(nvidia-smi -L | grep -m1 -o 'NVIDIA [^ ]*' | awk '{print $2}')
  if [ -z "$GPU" ]; then
    GPU="A10"
  fi
  export DOCKERFILE_PATH="dockerfiles/Dockerfile-$GPU"
  echo "DOCKERFILE_PATH set in session variable to dockerfiles/Dockerfile-$GPU"
else
  echo "DOCKERFILE_PATH already set to $DOCKERFILE_PATH"
fi

# Build the docker container
docker compose build
