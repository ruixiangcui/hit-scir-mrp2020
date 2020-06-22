#!/bin/bash

# examples of predicting commands

# DM
CUDA_VISIBLE_DEVICES=0 \
allennlp predict \
--cuda-device 0 \
--output-file dm-output.mrp \
--predictor transition_predictor_sdp \
--include-package utils \
--include-package modules \
--use-dataset-reader \
--batch-size 32 \
--silent \
checkpoints/dm_bert \
data/dm-test.mrp


# PSD
CUDA_VISIBLE_DEVICES=0 \
allennlp predict \
--cuda-device 0 \
--output-file psd-output.mrp \
--predictor transition_predictor_sdp \
--include-package utils \
--include-package modules \
--use-dataset-reader \
--batch-size 32 \
--silent \
checkpoints/psd_bert \
data/psd-test.mrp


# EDS
CUDA_VISIBLE_DEVICES=0 \
allennlp predict \
--cuda-device 0 \
--output-file eds-output.mrp \
--predictor transition_predictor_eds \
--include-package utils \
--include-package modules \
--use-dataset-reader \
--batch-size 32 \
--silent \
checkpoints/eds_bert \
data/eds-test.mrp


# UCCA
CUDA_VISIBLE_DEVICES=0 \
allennlp predict \
--cuda-device 0 \
--output-file ucca-output.mrp \
--predictor transition_predictor_ucca \
--include-package utils \
--include-package modules \
--use-dataset-reader \
--batch-size 32 \
--silent \
checkpoints/ucca_bert \
data/ucca-test.mrp


# AMR
# !!! AMR parser accepts input of augmented amr format instead of mrp format !!!
CUDA_VISIBLE_DEVICES=0 \
allennlp predict \
--cuda-device 0 \
--output-file amr-output.mrp \
--predictor transition_predictor_amr \
--include-package utils \
--include-package modules \
--use-dataset-reader \
--batch-size 32 \
--silent \
checkpoints/amr_bert \
data/amr-test.txt
=======
#SBATCH --mem=30G
#SBATCH --time=0-10
#SBATCH --array=1-3

# UCCA
for split in dev test; do
  allennlp predict \
  --cuda-device -1 \
  --output-file data/ucca-output$SLURM_ARRAY_TASK_ID.$split.mrp \
  --predictor transition_predictor_ucca \
  --include-package utils \
  --include-package modules \
  --include-package metrics \
  --use-dataset-reader \
  --batch-size 32 \
  --silent \
  checkpoints/ucca_bert${PREFIX:-}$SLURM_ARRAY_TASK_ID \
  data/ewt.$split.aug.companion.mrp

  mkdir -p data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split
  python toolkit/mtool/main.py data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split.mrp data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split.xml --read mrp --write ucca
  csplit -zk data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split.xml '/^<root/' -f '' -b "data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split/%03d.xml" {553}
  python -m semstr.evaluate data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.dev data/ewt/dev -qs ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.dev.scores.txt
done

  python toolkit/mtool/main.py data/ucca-output1.test.mrp data/ucca-output1.test.xml --read mrp --write ucca
  csplit -zk data/ucca-output1.dev.xml '/^<root/' -f '' -b "data/ucca-output1.dev/%03d.xml" {534}

  perl -nle 'print $& while m{(?<=passageID=")[^"]*(?=")}g' data/ucca-output1.dev/* > data/devname.txt
  for file in *.xml; do read line; mv -v "${file}" "${line}.xml"; done < ../devname.txt

  python -m semstr.evaluate data/ucca-output1.dev data/ewt/dev -qs ucca-output1.dev.scores.txt

  python toolkit/mtool/main.py data/ucca-output1.dev.mrp data/ucca-output1.dev.xml --read mrp --write ucca
>>>>>>> d47f95f... .
