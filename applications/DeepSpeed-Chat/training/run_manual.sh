#!/bin/bash

NODES=10nodes
NSLOTS=1

for MODEL in "opt-350m"
do
        for BATCH in 10
        do
            python3 make_batch.py nodes/${NODES}.txt hostfiles/${NODES}_${BATCH}xN --batchsize ${BATCH} --append slots=${NSLOTS}
            ./run_batch.sh run_${MODEL} hostfiles/${NODES}_${BATCH}xN output/${NODES}_${BATCH}xN_${MODEL} 1500
            python3 eval_batch.py output/${NODES}_${BATCH}xN_${MODEL} results/${NODES}_${BATCH}xN_${MODEL}.csv 6000
        done
done
