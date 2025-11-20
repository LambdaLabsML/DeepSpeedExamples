#!/bin/bash

# Check if vm.max_map_count is lower than recommended
max_map_count_val=$(sysctl -n vm.max_map_count)
if [ "$max_map_count_val" -lt 1500000 ]; then
    echo "WARNING: vm.max_map_count is not set to 1500000."
    echo "You may want to run 'make env' if running on a cluster"
fi

# Build the docker container
docker compose build

