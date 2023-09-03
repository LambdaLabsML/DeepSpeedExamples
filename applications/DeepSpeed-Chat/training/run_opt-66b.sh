#!/bin/bash

CONFIG_NAME=${1:-"8xH100"}
HOSTFILE_NAME=${2:-""}

# Step 1
source ./setup_env.sh opt-66b 1 && \
deepspeed --hostfile=./hostfiles/$HOSTFILE_NAME $SCRIPT_PATH/main.py \
   --data_path Dahoas/rm-static Dahoas/full-hh-rlhf Dahoas/synthetic-instruct-gptj-pairwise yitingxie/rlhf-reward-datasets \
   --data_split 2,4,4 \
   --data_output_path $DATA_OUTPUT_PATH \
   --model_name_or_path $MODEL_NAME \
   --per_device_train_batch_size 4 \
   --per_device_eval_batch_size 4 \
   --max_seq_len 512 \
   --learning_rate 1e-8 \
   --weight_decay 0.1 \
   --num_train_epochs 2  \
   --gradient_accumulation_steps 1 \
   --lr_scheduler_type cosine \
   --num_warmup_steps 0 \
   --seed 1234 \
   --gradient_checkpointing \
   --zero_stage $ZERO_STAGE \
   --lora_dim 128 \
   --lora_module_name decoder.layers. \
   --deepspeed \
   --max_steps 100 | tee ${OUTPUT}_${CONFIG_NAME}.log

