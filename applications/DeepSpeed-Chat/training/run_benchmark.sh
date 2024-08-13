#!/bin/bash
NODES=${1:-"hosts"}
CLUSTER_SIZE=${2:-1}
MODEL=${3:-"opt-13b_bs16_zero0"}
NSLOTS=${4:-8}
TIMEOUT=${5:-1200}

# Declare an associative array for expected throughput values
declare -A THROUGHPUTS
THROUGHPUTS[opt-350m_bs24_zero0]=900
THROUGHPUTS[opt-13b_bs16_zero0]=70

# Access the throughput directly from the array using the model as the key
THROUGHPUT=${THROUGHPUTS[$MODEL]}

# Create hostfiles for this run
python3 make_batch.py nodes/${NODES}.txt hostfiles/${NODES}_${CLUSTER_SIZE}xN --batchsize ${CLUSTER_SIZE} --append slots=${NSLOTS}
        
# Run jobs in batch
./run_batch.sh run_${MODEL} hostfiles/${NODES}_${CLUSTER_SIZE}xN output/${NODES}_${CLUSTER_SIZE}xN_${MODEL} $TIMEOUT

# Collect throughput from log file and evaluate
THROUGHPUT_SCALED=$(($THROUGHPUT * $CLUSTER_SIZE))   
python3 eval_batch.py output/${NODES}_${CLUSTER_SIZE}xN_${MODEL} results/${NODES}_${CLUSTER_SIZE}xN_${MODEL}.csv $THROUGHPUT_SCALED

# Kill potential hanging jobs
./kill_process.sh nodes/${NODES}.txt python
sleep 30
