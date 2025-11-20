#!/bin/bash

read -p "You are about to reconfigure the Docker daemon. Doing so may affect other running Docker containers. Do you want to continue? (y/n): " answer

if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "Operation cancelled by user."
    exit 1
fi
 
# Install utility for modifying JSON
apt-get update
apt-get install jq -y

# Move docker daemon's data-dir to a new spacious mount
mkdir -p /docker
mount -t tmpfs -o size=500G tmpfs /docker
touch /etc/docker/daemon_tmp.json
jq '. + {"data-root": "/docker"}' /etc/docker/daemon.json | tee /etc/docker/daemon_tmp.json > /dev/null
mv /etc/docker/daemon_tmp.json /etc/docker/daemon.json
sudo systemctl restart docker
 
# Set vm.max_map_count as specified in 
# https://lambdalabs.atlassian.net/wiki/spaces/HPC/pages/582844431/DeepSpeed+Cluster+ML+Test+Guide#Adjust-file-and-memory-limits-if-necessary-(%3E32-nodes)
sudo sysctl -w vm.max_map_count=1500000

