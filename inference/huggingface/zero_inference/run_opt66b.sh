#!/bin/bash
export USE_TF=0 
BASE_LOG_DIR=./experiments/zero_inference/
MODEL_NAME="opt-66b"
FULL_MODEL_NAME="facebook/${MODEL_NAME}"
QB=4

. .env
. ${ENV_PATH}/bin/activate

# zero-inference
BSZ=1
LOG_DIR=$BASE_LOG_DIR/${MODEL_NAME}_bs${BSZ}
mkdir -p  $LOG_DIR
deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}.txt 
# deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --cpu-offload --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}_cpu.txt 
# deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --cpu-offload --kv-offload --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}_cpu_kv.txt 

# # zero-inference
# BSZ=2
# LOG_DIR=$BASE_LOG_DIR/${MODEL_NAME}_bs${BSZ}
# mkdir -p  $LOG_DIR
# deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}.txt 
# deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --cpu-offload --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}_cpu.txt 
# deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --cpu-offload --kv-offload --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}_cpu_kv.txt 



# BSZ=4
# LOG_DIR=$BASE_LOG_DIR/${MODEL_NAME}_bs${BSZ}
# mkdir -p  $LOG_DIR
# deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}.txt 
# deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --cpu-offload --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}_cpu.txt 
# deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --cpu-offload --kv-offload --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}_cpu_kv.txt 


# BSZ=8
# LOG_DIR=$BASE_LOG_DIR/${MODEL_NAME}_bs${BSZ}
# mkdir -p  $LOG_DIR
# deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}.txt 
# deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --cpu-offload --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}_cpu.txt 
# deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --cpu-offload --kv-offload --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}_cpu_kv.txt 

# BSZ=16
# LOG_DIR=$BASE_LOG_DIR/${MODEL_NAME}_bs${BSZ}
# mkdir -p  $LOG_DIR
# deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}.txt 
# deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --cpu-offload --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}_cpu.txt 
# deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --cpu-offload --kv-offload --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}_cpu_kv.txt 

# BSZ=32
# LOG_DIR=$BASE_LOG_DIR/${MODEL_NAME}_bs${BSZ}
# mkdir -p  $LOG_DIR
# deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}.txt 
# deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --cpu-offload --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}_cpu.txt 
# deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --cpu-offload --kv-offload --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}_cpu_kv.txt 


# # BSZ=64
# LOG_DIR=$BASE_LOG_DIR/${MODEL_NAME}_bs${BSZ}
# mkdir -p  $LOG_DIR
# deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --cpu-offload --kv-offload --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}_cpu_kv.txt 
# deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --cpu-offload --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}_cpu.txt 
# deepspeed --include localhost:0 run_model.py --model ${FULL_MODEL_NAME} --batch-size ${BSZ} --gen-len 32 --pin-memory 1 --quant_bit ${QB} --cpu-offload --kv-offload --log-file $LOG_DIR/ds_${MODEL_NAME}_bs${BSZ}_pin_q${QB}_cpu_kv.txt 

