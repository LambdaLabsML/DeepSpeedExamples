# Benchmark DeepSpeed-Chat Training on GCP-A3

## Setup
Prerequisites
* Add all worker nodes to nodes/hosts.txt
* Add the first worker node to nodes/1node.txt

Next, run the `setup_deepchat.sh` script. This will take ~30 mins including caching model and datasets. It will also launch the RXDM container on all worker nodes.

```
export SHARED_STORAGE=$HOME & \
export PROJECT_PATH=${SHARED_STORAGE}/benchmark && \
wget https://raw.githubusercontent.com/LambdaLabsML/DeepSpeedExamples/gcp-a3/applications/DeepSpeed-Chat/training/setup_deepchat.sh && \
chmod +x setup_deepchat.sh && \
./setup_deepchat.sh
```

# Run benchmark
```
# Benchmark opt-350m_bs24_zero0 on a single node 
# node1: name of the hostfile that only has node-001 in it
# 1    : sub-cluster size
# opt-350m_bs24_zero0: name of the benchmark script (see opt-350m_bs24_zero0.sh for details)
cd ${PROJECT_PATH}/DeepSpeedExamples/applications/DeepSpeed-Chat/training && \
./run_benchmark.sh node1 1 opt-350m_bs24_zero0

# Sub-divide ./nodes/hosts.txt into smaller clusters of size 2, and benchmark opt-350m_bs24_zero0 on these clusters in parallel.
# hosts: name of the hostfile
# 2    : sub-cluster size
cd ${PROJECT_PATH}/DeepSpeedExamples/applications/DeepSpeed-Chat/training && \
./run_benchmark.sh hosts 2 opt-350m_bs24_zero0

# Benchmark opt-13b_bs16_zero0 first with node-001
# then with four 16x nodes sub-divided clusters in parallel (assuming there are 64 nodes in ./nodes/hosts.txt)
# and finally with the entire cluster with 64x nodes
./run_benchmark.sh node1 1 opt-13b_bs16_zero0
./run_benchmark.sh hosts 16 opt-13b_bs16_zero0
./run_benchmark.sh hosts 64 opt-13b_bs16_zero0
```

The throughputs will be saved to the csv files inside `./results`. Full console output will be saved in the log files in the `./output` folder.


# Results
Here are the reference throughputs (`samples/sec`) of a 2x nodes (16x NVIDIA H100s) GCP-A3 cluster

| NUM_GPUs | opt-350m_bs24_zero0 | opt-13b_bs16_zero0 |
|----------|---------------------|--------------------|
| 8        |      942        |       72      |
| 16       |     1853       |      142       |
