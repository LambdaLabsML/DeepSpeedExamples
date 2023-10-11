#!/bin/bash

NODES=all-nodes-v2

for MODEL in "opt-350m" "opt-13b_bs16_zero0"
do
        for BATCH in 1 2 4 8 16 32
        do
            python3 make_batch.py nodes/${NODES}.txt hostfiles/${NODES}_${BATCH}xN --batchsize ${BATCH}
            ./run_batch.sh run_${MODEL} hostfiles/${NODES}_${BATCH}xN output/${NODES}_${BATCH}xN_${MODEL} 1500
            python3 eval_batch.py output/${NODES}_${BATCH}xN_${MODEL} results/${NODES}_${BATCH}xN_${MODEL}.csv 6000
        done
done
