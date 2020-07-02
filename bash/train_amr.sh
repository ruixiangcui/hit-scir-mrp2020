#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=1-0
#SBATCH -p gpu --gres=gpu:titanx:1

# AMR
# !!! AMR parser accepts input of augmented amr format instead of mrp format !!!
CUDA_VISIBLE_DEVICES=0 \
TRAIN_PATH=data/amr-train.mrp.actions.aug.txt \
DEV_PATH=data/amr-dev.mrp.actions.aug.txt \
BERT_PATH=bert/wwm_cased_L-24_H-1024_A-16 \
WORD_DIM=1024 \
LOWER_CASE=FALSE \
BATCH_SIZE=4 \
allennlp train \
-s checkpoints/amr_bert \
--include-package utils \
--include-package modules \
--file-friendly-logging \
config/transition_bert_amr.jsonnet