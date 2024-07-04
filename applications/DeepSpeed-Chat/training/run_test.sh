#!/bin/bash
NODES=${1:-"allnodes"}
CLUSTER_SIZE=${2:-8}
NSLOTS=8
TIMEOUT=900

# Declare an associative array for throughput values
declare -A THROUGHPUTS
THROUGHPUTS[opt-350m_bs24]=500
THROUGHPUTS[opt-13b_bs16_zero0]=65

BATCHES="1 2 ${CLUSTER_SIZE}"
[[ "$CLUSTER_SIZE" -eq 1 ]] && BATCHES="1"

# Add more models here as needed
for MODEL in "opt-350m_bs24" "opt-13b_bs16_zero0" # Add more models to this list as needed
do
    # Access the throughput directly from the array using the model as the key
    THROUGHPUT=${THROUGHPUTS[$MODEL]}

    for BATCH in $BATCHES; do
        # Create hostfiles for this run
        python3 make_batch.py nodes/${NODES}.txt hostfiles/${NODES}_${BATCH}xN --batchsize ${BATCH} --append slots=${NSLOTS}
             
        # Run jobs in batch
        ./run_batch.sh run_${MODEL} hostfiles/${NODES}_${BATCH}xN output/${NODES}_${BATCH}xN_${MODEL} $TIMEOUT
        
        # Collect throughput from log file and evaluate
        THROUGHPUT_SCALED=$(($THROUGHPUT * $BATCH))   
        python3 eval_batch.py output/${NODES}_${BATCH}xN_${MODEL} results/${NODES}_${BATCH}xN_${MODEL}.csv $THROUGHPUT_SCALED
        
        # Kill potential hanging jobs
        ./kill_process.sh nodes/${NODES}.txt python
        sleep 60
    done
done