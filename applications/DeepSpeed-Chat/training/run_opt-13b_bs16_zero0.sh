#!/bin/bash

JOB_NAME=${1:-"1xN"}
HOSTFILE_NAME=${2:-""}
OUTPUT_PATH=${3:-"output"}

# Step 1
MODEL_NAME=opt-13b
STEP_NAME=1

NAME_LOG=${OUTPUT_PATH}/${MODEL_NAME}_${STEP_NAME}_${JOB_NAME}.log
cat $HOSTFILE_NAME | tee $NAME_LOG
echo >> $NAME_LOG

source ./setup_env.sh $MODEL_NAME $STEP_NAME && \
NCCL_DEBUG=INFO /home/ubuntu/.local/bin/deepspeed --hostfile=$HOSTFILE_NAME $SCRIPT_PATH/main.py \
   --data_path Dahoas/rm-static Dahoas/full-hh-rlhf Dahoas/synthetic-instruct-gptj-pairwise yitingxie/rlhf-reward-datasets \
   --data_split 2,4,4 \
   --data_output_path $DATA_OUTPUT_PATH \
   --model_name_or_path $MODEL_PATH \
   --per_device_train_batch_size 16 \
   --per_device_eval_batch_size 4 \
   --max_seq_len 512 \
   --learning_rate 1e-10 \
   --weight_decay 0.1 \
   --num_train_epochs 100  \
   --gradient_accumulation_steps 1 \
   --lr_scheduler_type cosine \
   --num_warmup_steps 0 \
   --seed 1234 \
   --gradient_checkpointing \
   --zero_stage 0 \
   --lora_dim 128 \
   --lora_module_name decoder.layers. \
   --deepspeed \
   --max_steps 100 2>&1 | tee -a $NAME_LOG

