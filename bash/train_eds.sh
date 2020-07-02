#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=1-0
#SBATCH -p gpu --gres=gpu:titanx:1

# EDS
CUDA_VISIBLE_DEVICES=0 \
TRAIN_PATH=data/test.mrp \
DEV_PATH=data/testval.mrp \
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