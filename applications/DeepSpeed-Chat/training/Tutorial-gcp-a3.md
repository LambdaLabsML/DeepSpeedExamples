# Benchmark DeepSpeed-Chat Training on GCP-A3

## Setup

Simply provide the name of the shared stroage (where the code will be cloned and data will be cachced), and run the `setup_deepchat.sh` script.

```
# Tell me where is your shared storage
export SHARED_STORAGE=$HOME

# Setup the benchmark
# This will take ~30 mins including caching model and datasets
# It will also create a couple of hostfiles
# ./nodes/node1.txt for the first node: node-001
# ./nodes/hosts.txt for all the nodes
export PROJECT_PATH=${SHARED_STORAGE}/benchmark && \
wget https://raw.githubusercontent.com/LambdaLabsML/DeepSpeedExamples/gcp-a3/applications/DeepSpeed-Chat/training/setup_deepchat.sh && \
chmod +x setup_deepchat.sh && \
./setup_deepchat.sh
```


