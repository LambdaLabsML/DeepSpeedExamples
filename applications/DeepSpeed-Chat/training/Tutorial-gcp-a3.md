# Benchmark DeepSpeed-Chat Training on Lambda 1-Click Clusters

## Setup

Simply provide the name of the shared stroage (where the code will be cloned and data will be cachced), and run the `setup_deepchat.sh` script.

```
# Tell me where is your shared storage
export SHARED_STORAGE=<NAME-OF-SHARED-STORAGE>

# Setup the benchmark
# This will take ~30 mins including caching model and datasets
# It will also create a couple of hostfiles
# ./nodes/node1.txt for the first node: node-001
# ./nodes/hosts.txt for all the nodes
export PROJECT_PATH=/home/ubuntu/${SHARED_STORAGE}/benchmark && \
wget https://raw.githubusercontent.com/LambdaLabsML/DeepSpeedExamples/master/applications/DeepSpeed-Chat/training/setup_deepchat.sh && \
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
Here are the reference throughputs (`samples/sec`) of a 64x nodes (512x NVIDIA H100s) 1-Click Cluster.

| NUM_GPUs | opt-350m_bs24_zero0 | opt-13b_bs16_zero0 |
|----------|---------------------|--------------------|
| 8        |      943        |       73       |
| 16       |     1874        |      146       |
| 32       |     3729        |      290       |
| 64       |     7443        |      580       |
| 128      |    14900        |     1157       |
| 256      |    29750        |     2294       |
| 512      |    59233        |     4587       |


<p align="center">
  <img src="./imgs/Scalability_OPT-350M.png" alt="OPT-350M" title="Scalability for OPT-350M across a 64xNodes (512x NVIDIA H100) Cluster">
  <img src="./imgs/Scalability_OPT-13B.png" alt="OPT-13B" title="Scalability for OPT-13B across a 64xNodes (512x NVIDIA H100) Cluster">
</p>
