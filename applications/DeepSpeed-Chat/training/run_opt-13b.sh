#!/bin/bash


# --- GPU arch (auto-detect) ---
GPU_ARCH=$(nvidia-smi --query-gpu=compute_cap --format=csv,noheader | head -1)
export TORCH_CUDA_ARCH_LIST="${GPU_ARCH}"

# --- Shared extension cache directory ---
export TORCH_EXTENSIONS_DIR="${PROJECT_PATH}/.cache/torch_extensions"

# --- CUDA toolkit location ---
export CUDA_HOME="/usr/local/cuda"
export PATH="${CUDA_HOME}/bin:${PATH}"
export LD_LIBRARY_PATH="${CUDA_HOME}/lib64:${LD_LIBRARY_PATH:-}"

# --- Build behavior ---
export MAX_JOBS=1          # safer on multi-rank builds
export DS_BUILD_VERBOSE=1  # show build logs for first compile

# --- Optional NCCL/diagnostics helpers ---
export NCCL_DEBUG=INFO
export TORCH_NCCL_ASYNC_ERROR_HANDLING=1
JOB_NAME=${1:-"1xN"}
HOSTFILE_NAME=${2:-""}
OUTPUT_PATH=${3:-"output"}

# # Step 1
# MODEL_NAME=opt-13b
# STEP_NAME=1

# NAME_LOG=${OUTPUT_PATH}/${MODEL_NAME}_${STEP_NAME}_${JOB_NAME}.log
# cat $HOSTFILE_NAME | tee $NAME_LOG
# echo >> $NAME_LOG

# source ./setup_env.sh $MODEL_NAME $STEP_NAME && \
# NCCL_DEBUG=INFO deepspeed --hostfile=$HOSTFILE_NAME $SCRIPT_PATH/main.py \
#    --data_path Dahoas/rm-static Dahoas/full-hh-rlhf Dahoas/synthetic-instruct-gptj-pairwise yitingxie/rlhf-reward-datasets \
#    --data_split 2,4,4 \
#    --data_output_path $DATA_OUTPUT_PATH \
#    --model_name_or_path $MODEL_PATH \
#    --per_device_train_batch_size 4 \
#    --per_device_eval_batch_size 4 \
#    --max_seq_len 512 \
#    --learning_rate 1e-10 \
#    --weight_decay 0.1 \
#    --num_train_epochs 1000  \
#    --gradient_accumulation_steps 1 \
#    --lr_scheduler_type cosine \
#    --num_warmup_steps 0 \
#    --seed 1234 \
#    --gradient_checkpointing \
#    --zero_stage $ZERO_STAGE \
#    --lora_dim 128 \
#    --lora_module_name decoder.layers. \
#    --deepspeed \
#    --max_steps 100 2>&1 | tee -a $NAME_LOG


# # Step 2
# MODEL_NAME=opt-350m
# STEP_NAME=2

# NAME_LOG=${OUTPUT_PATH}/${MODEL_NAME}_${STEP_NAME}_${JOB_NAME}.log
# cat $HOSTFILE_NAME | tee $NAME_LOG
# echo >> $NAME_LOG

# source ./setup_env.sh $MODEL_NAME $STEP_NAME && \
# NCCL_DEBUG=INFO deepspeed --hostfile=$HOSTFILE_NAME $SCRIPT_PATH/main.py \
#    --data_path Dahoas/rm-static Dahoas/full-hh-rlhf Dahoas/synthetic-instruct-gptj-pairwise yitingxie/rlhf-reward-datasets \
#    --data_split 2,4,4 \
#    --data_output_path $DATA_OUTPUT_PATH \
#    --model_name_or_path $MODEL_NAME \
#    --num_padding_at_beginning 1 \
#    --per_device_train_batch_size 4 \
#    --per_device_eval_batch_size 4 \
#    --max_seq_len 512 \
#    --learning_rate 1e-10 \
#    --weight_decay 0.1 \
#    --num_train_epochs 1000 \
#    --disable_dropout \
#    --gradient_accumulation_steps 1 \
#    --lr_scheduler_type cosine \
#    --num_warmup_steps 0 \
#    --seed 1234 \
#    --zero_stage $ZERO_STAGE \
#    --deepspeed \
#    --max_steps 100 2>&1 | tee -a $NAME_LOG



# Step 3
MODEL_NAME=opt-13b
STEP_NAME=3

NAME_LOG=${OUTPUT_PATH}/${MODEL_NAME}_${STEP_NAME}_${JOB_NAME}.log
cat $HOSTFILE_NAME | tee $NAME_LOG
echo >> $NAME_LOG

source ./setup_env.sh $MODEL_NAME $STEP_NAME && \
NCCL_DEBUG=INFO PROJECT_PATH=${PROJECT_PATH} deepspeed --hostfile=$HOSTFILE_NAME --master_port 12346 $SCRIPT_PATH/main.py \
   --data_path Dahoas/rm-static Dahoas/full-hh-rlhf Dahoas/synthetic-instruct-gptj-pairwise yitingxie/rlhf-reward-datasets \
   --data_split 2,4,4 \
   --data_output_path $DATA_OUTPUT_PATH \
   --actor_model_name_or_path $ACTOR_MODEL_CACHE \
   --critic_model_name_or_path $CRITIC_MODEL_CACHE \
   --num_padding_at_beginning 1 \
   --per_device_train_batch_size 16 \
   --per_device_mini_train_batch_size 16 \
   --generation_batch_numbers 1 \
   --ppo_epochs 1 \
   --max_answer_seq_len 256 \
   --max_prompt_seq_len 256 \
   --actor_learning_rate 1e-10 \
   --critic_learning_rate 1e-10 \
   --num_train_epochs 5 \
   --lr_scheduler_type cosine \
   --gradient_accumulation_steps 1 \
   --num_warmup_steps 100 \
   --deepspeed --seed 1234 \
   --enable_hybrid_engine \
   --inference_tp_size 1 \
   --actor_zero_stage $ACTOR_ZERO_STAGE \
   --critic_zero_stage $CRITIC_ZERO_STAGE \
   --actor_gradient_checkpointing \
   --disable_actor_dropout \
   --actor_lora_dim 128 \
   --actor_lora_module_name decoder.layers. \
   --max_steps 50 2>&1 | tee -a $NAME_LOG
