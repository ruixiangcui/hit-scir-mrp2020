#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=5-0
#SBATCH -p gpu --gres=gpu:titanrtx:1
#SBATCH -c10

# EDS
CUDA_VISIBLE_DEVICES=0 \
TRAIN_PATH=data/train.mrp \
DEV_PATH=data/val.mrp \
BERT_PATH=bert/wwm_cased_L-24_H-1024_A-16 \
WORD_DIM=1024 \
LOWER_CASE=FALSE \
BATCH_SIZE=4 \
allennlp train \
-s checkpoints/eds_bert \
--include-package utils \
--include-package modules \
--file-friendly-logging \
config/transition_bert_eds.jsonnet