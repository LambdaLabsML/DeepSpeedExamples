# Benchmark DeepSpeed-Chat Training on Lambda 1-Click Clusters

## Set up
```
# Tell me where is your shared storage
export SHARED_STORAGE=<NAME-OF-SHARED-STORAGE> && \
export PROJECT_PATH=/home/ubuntu/${SHARED_STORAGE}/benchmark

# Setup the repo
wget https://raw.githubusercontent.com/LambdaLabsML/DeepSpeedExamples/master/applications/DeepSpeed-Chat/./setup_deepchat.sh && \
./setup_deepchat.sh
```


# Run benchmark
```
# Benchmark node-001
# node1: name of the hostfile
# 1    : cluster size (in this case only one node)
# opt-350m_bs24_zero0: name of the benchmark script (see opt-350m_bs24_zero0.sh for details)
./run_benchmark.sh node1 1 opt-350m_bs24_zero0

# Sub-divide ./nodes/hosts.txt into smaller clusters, and benchmark them in parallel.
# hosts: name of the hostfile
# 2    : sub-cluster size (in this case each cluster has two nodes)
./run_benchmark.sh hosts 2 opt-350m_bs24_zero0
```

The throughputs will be saved to the csv files inside `./results`. Full console output will be saved in the log files in the `./output` folder.

