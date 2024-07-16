#!/bin/bash

# Create virtual envrionment on home directory (shared across all workers)
virtualenv -p /usr/bin/python3.11 venv-gcp && \
. venv-gcp/bin/activate && \
pip install deepspeed==0.14.4 && \
wget https://raw.githubusercontent.com/LambdaLabsML/DeepSpeedExamples/master/applications/DeepSpeed-Chat/requirements_freeze.txt && pip install --upgrade -r requirements_freeze.txt && rm requirements_freeze.txt


# Clone the repo
mkdir -p $PROJECT_PATH && \
cd ${PROJECT_PATH} && \
git clone https://github.com/LambdaLabsML/DeepSpeedExamples.git && \
cd DeepSpeedExamples/applications/DeepSpeed-Chat/training && \
git checkout gcp-a3

# Add PROJECT_PATH to deepspeed config file
sed -i "1s|^PROJECT_PATH=.*|PROJECT_PATH=$PROJECT_PATH|" .deepspeed_env

# Install dependencis on all worker nodes
./install_dependencies.sh ./nodes/hosts.txt

# Cache models and datasets use node-001
export NODE1=$(head -1 ./nodes/hosts.txt) && \
mkdir -p ${PROJECT_PATH}/.cache/huggingface/transformers && \
mkdir -p ${PROJECT_PATH}/.cache/huggingface/datasets && \
cmd_create_data="export PROJECT_PATH=${PROJECT_PATH} && cd ${PROJECT_PATH}/DeepSpeedExamples/applications/DeepSpeed-Chat/training && ./cache_data.sh" && \
ssh "$NODE1" "$cmd_create_data"
