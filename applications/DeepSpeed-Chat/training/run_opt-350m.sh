#!/bin/bash

JOB_NAME=${1:-"1xN"}
HOSTFILE_NAME=${2:-""}
OUTPUT_PATH=${3:-"output"}

# Step 2
MODEL_NAME=opt-350m
STEP_NAME=2

NAME_LOG=${OUTPUT_PATH}/${MODEL_NAME}_${STEP_NAME}_${JOB_NAME}.log
cat $HOSTFILE_NAME | tee $NAME_LOG
echo >> $NAME_LOG

source ./setup_env.sh $MODEL_NAME $STEP_NAME

NCCL_DEBUG=WARN PROJECT_PATH=${PROJECT_PATH} /home/${USER}/.local/bin/deepspeed --hostfile=$HOSTFILE_NAME $SCRIPT_PATH/main.py \
   --data_path Dahoas/rm-static Dahoas/rm-static Dahoas/rm-static Dahoas/rm-static Dahoas/rm-static Dahoas/rm-static Dahoas/rm-static Dahoas/rm-static Dahoas/full-hh-rlhf Dahoas/synthetic-instruct-gptj-pairwise yitingxie/rlhf-reward-datasets \
   --data_split 2,4,4 \
   --data_output_path $DATA_OUTPUT_PATH \
   --model_name_or_path $MODEL_PATH \
   --num_padding_at_beginning 1 \
   --per_device_train_batch_size 4 \
   --per_device_eval_batch_size 4 \
   --max_seq_len 512 \
   --learning_rate 1e-10 \
   --weight_decay 0.1 \
   --num_train_epochs 1000 \
   --disable_dropout \
   --gradient_accumulation_steps 1 \
   --lr_scheduler_type cosine \
   --num_warmup_steps 0 \
   --seed 1234 \
   --zero_stage $ZERO_STAGE \
   --deepspeed \
   --max_steps 500 2>&1 | tee -a $NAME_LOG


# Fake benchmark
# source ./setup_env.sh $MODEL_NAME $STEP_NAME && \
# # echo $NAME_LOG
# source ~/.bashrc 

# ulimit -n
# echo $LLLLL
# hostname

# cat $HOSTFILE_NAME | tee $NAME_LOG
