#!/bin/bash

SCRIPT_NAME=opt-13b

mkdir -p output/188nodes_1xN_$SCRIPT_NAME
./run_${SCRIPT_NAME}.sh 188nodes_1xN hostfiles/188nodes_1xN/hostfile_1xN_batch0001 output/188nodes_1xN_$SCRIPT_NAME

mkdir -p output/188nodes_2xN_$SCRIPT_NAME
./run_${SCRIPT_NAME}.sh 188nodes_2xN hostfiles/188nodes_2xN/hostfile_2xN_batch0001 output/188nodes_2xN_$SCRIPT_NAME

mkdir -p output/188nodes_4xN_$SCRIPT_NAME
./run_${SCRIPT_NAME}.sh 188nodes_4xN hostfiles/188nodes_4xN/hostfile_4xN_batch0001 output/188nodes_4xN_$SCRIPT_NAME

mkdir -p output/188nodes_8xN_$SCRIPT_NAME
./run_${SCRIPT_NAME}.sh 188nodes_8xN hostfiles/188nodes_8xN/hostfile_8xN_batch0001 output/188nodes_8xN_$SCRIPT_NAME

mkdir -p output/188nodes_16xN_$SCRIPT_NAME
./run_${SCRIPT_NAME}.sh 188nodes_16xN hostfiles/188nodes_16xN/hostfile_16xN_batch0001 output/188nodes_16xN_$SCRIPT_NAME

mkdir -p output/188nodes_32xN_$SCRIPT_NAME
./run_${SCRIPT_NAME}.sh 188nodes_32xN hostfiles/188nodes_32xN/hostfile_32xN_batch0001 output/188nodes_32xN_$SCRIPT_NAME

mkdir -p output/188nodes_64xN_$SCRIPT_NAME
./run_${SCRIPT_NAME}.sh 188nodes_64xN hostfiles/188nodes_64xN/hostfile_64xN_batch0001 output/188nodes_64xN_$SCRIPT_NAME

mkdir -p output/188nodes_128xN_$SCRIPT_NAME
./run_${SCRIPT_NAME}.sh 188nodes_128xN hostfiles/188nodes_128xN/hostfile_128xN_batch0001 output/188nodes_128xN_$SCRIPT_NAME

mkdir -p output/188nodes_188xN_$SCRIPT_NAME
./run_${SCRIPT_NAME}.sh 188nodes_188xN hostfiles/188nodes_188xN/hostfile_188xN_batch0001 output/188nodes_188xN_$SCRIPT_NAME