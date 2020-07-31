#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=3-0
#SBATCH -p gpu --gres=gpu:titanrtx:1
#SBATCH -c10

CUDA_VISIBLE_DEVICES=0 \
TRAIN_PATH=data/cl/ucca.deu.aug.train.mrp \
DEV_PATH=data/cl/ucca.deu.aug.dev.mrp \
BERT_PATH=bert/multi_cased_L-12_H-768_A-12 \
WORD_DIM=1024 \
LOWER_CASE=FALSE \
BATCH_SIZE=4 \
allennlp train \
-s checkpoints/ucca_multi_bert \
--include-package utils \
--include-package modules \
--include-package metrics \
--file-friendly-logging \
config/transition_bert_ucca.jsonnet