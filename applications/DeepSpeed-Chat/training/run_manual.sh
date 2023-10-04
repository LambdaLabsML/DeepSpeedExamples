#!/bin/bash

python3 make_batch.py nodes/29nodes.txt hostfiles/29nodes_1xN --batchsize 1
# python3 make_batch.py nodes/29nodes.txt hostfiles/29nodes_2xN --batchsize 2
# python3 make_batch.py nodes/29nodes.txt hostfiles/29nodes_4xN --batchsize 4
# python3 make_batch.py nodes/29nodes.txt hostfiles/29nodes_8xN --batchsize 8
# python3 make_batch.py nodes/29nodes.txt hostfiles/29nodes_16xN --batchsize 16


./run_batch.sh run_opt-350m hostfiles/29nodes_1xN output/29nodes_1xN_opt-350m 1500
# ./run_batch.sh run_opt-350m hostfiles/29nodes_2xN output/29nodes_2xN_opt-350m 1500
# ./run_batch.sh run_opt-350m hostfiles/29nodes_4xN output/29nodes_4xN_opt-350m 1500
# ./run_batch.sh run_opt-350m hostfiles/29nodes_8xN output/29nodes_8xN_opt-350m 1500
# ./run_batch.sh run_opt-350m hostfiles/29nodes_16xN output/29nodes_16xN_opt-350m 1500

./run_batch.sh run_opt-13b_bs16_zero0 hostfiles/29nodes_1xN output/29nodes_1xN_opt-13b_bs16_zero0 3000

# ./run_batch.sh run_opt-13b_bs16_zero0 hostfiles/29nodes_2xN output/29nodes_2xN_opt-13b_bs16_zero0 3000
# ./run_batch.sh run_opt-13b_bs16_zero0 hostfiles/29nodes_4xN output/29nodes_4xN_opt-13b_bs16_zero0 3000
# ./run_batch.sh run_opt-13b_bs16_zero0 hostfiles/29nodes_8xN output/29nodes_8xN_opt-13b_bs16_zero0 3000
# ./run_batch.sh run_opt-13b_bs16_zero0 hostfiles/29nodes_16xN output/29nodes_16xN_opt-13b_bs16_zero0 3000


python3 eval_batch.py output/29nodes_1xN_opt-350m results/29nodes_1xN_opt-350m.csv 600
# python3 eval_batch.py output/29nodes_2xN_opt-350m results/29nodes_2xN_opt-350m.csv 600
# python3 eval_batch.py output/29nodes_4xN_opt-350m results/29nodes_4xN_opt-350m.csv 1200
# python3 eval_batch.py output/29nodes_8xN_opt-350m results/29nodes_8xN_opt-350m.csv 2300
# python3 eval_batch.py output/29nodes_16xN_opt-350m results/29nodes_16xN_opt-350m.csv 4200

# python3 eval_batch.py output/29nodes_2xN_opt-13b_bs16_zero0 results/29nodes_2xN_opt-13b_bs16_zero0.csv 130
# python3 eval_batch.py output/29nodes_4xN_opt-13b_bs16_zero0 results/29nodes_4xN_opt-13b_bs16_zero0.csv 260
# python3 eval_batch.py output/29nodes_8xN_opt-13b_bs16_zero0 results/29nodes_8xN_opt-13b_bs16_zero0.csv 520
# python3 eval_batch.py output/29nodes_16xN_opt-13b_bs16_zero0 results/29nodes_16xN_opt-13b_bs16_zero0.csv 1000
