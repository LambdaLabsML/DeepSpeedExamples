#!/bin/bash

# Add PROJECT_PATH to deepspeed config file
sed -i "1s|^PROJECT_PATH=.*|PROJECT_PATH=$PROJECT_PATH|" .deepspeed_env

# Create hostfiles
# ./nodes/node1.txt has node-001
# ./nodes/hosts.txt has all nodes
mkdir -p ./nodes && grep '\-node\-' /etc/hosts | awk '{print $2}' > ./nodes/hosts.txt && \
export NODE1=$(head -1 ./nodes/hosts.txt) && \
echo $NODE1 > nodes/node1.txt

# Install dependencis on all worker nodes
./install_dependencies.sh ./nodes/hosts.txt

# Cache models and datasets
mkdir -p ${PROJECT_PATH}/.cache/huggingface/transformers && \
mkdir -p ${PROJECT_PATH}/.cache/huggingface/datasets && \
cmd_create_data="export PROJECT_PATH=${PROJECT_PATH} && cd ${PROJECT_PATH}/DeepSpeedExamples/applications/DeepSpeed-Chat/training && ./cache_data.sh" && \
ssh "$NODE1" "$cmd_create_data"