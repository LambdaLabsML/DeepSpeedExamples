#!/bin/bash

# Step 1
source ./setup_env.sh opt-13b 1 && \
deepspeed $SCRIPT_PATH/main.py \
   --data_path Dahoas/rm-static Dahoas/full-hh-rlhf Dahoas/synthetic-instruct-gptj-pairwise yitingxie/rlhf-reward-datasets \
   --data_split 2,4,4 \
   --data_output_path $DATA_OUTPUT_PATH \
   --model_name_or_path $MODEL_PATH \
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
   --skip_train


# Step 2

source ./setup_env.sh opt-350m 2 && \
deepspeed --hostfile=./hostfiles/$HOSTFILE_NAME $SCRIPT_PATH/main.py \
   --data_path Dahoas/rm-static Dahoas/full-hh-rlhf Dahoas/synthetic-instruct-gptj-pairwise yitingxie/rlhf-reward-datasets \
   --data_split 2,4,4 \
   --data_output_path $DATA_OUTPUT_PATH \
   --model_name_or_path $MODEL_PATH \
   --num_padding_at_beginning 1 \
   --per_device_train_batch_size 4 \
   --per_device_eval_batch_size 4 \
   --max_seq_len 512 \
   --learning_rate 5e-5 \
   --weight_decay 0.1 \
   --num_train_epochs 1 \
   --disable_dropout \
   --gradient_accumulation_steps 1 \
   --lr_scheduler_type cosine \
   --num_warmup_steps 0 \
   --seed 1234 \
   --zero_stage $ZERO_STAGE \
   --deepspeed \
   --skip_train


# Step 3
source ./setup_env.sh opt-13b 3 && \
deepspeed --hostfile=./hostfiles/$HOSTFILE_NAME --master_port 12346 $SCRIPT_PATH/main.py \
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
   --actor_learning_rate 5e-4 \
   --critic_learning_rate 5e-6 \
   --num_train_epochs 1 \
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
   --skip_train
