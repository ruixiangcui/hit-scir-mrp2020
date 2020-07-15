#!/bin/bash

mkdir -p data

# Download mrp2020 data from https://drive.google.com/file/d/1llyl-agwFL7QwSk5kkFUSbbzF3ajBeNw/view | unzip and put in content root

#Convert augment data from mrp to conllu
python toolkit/mrp2conllu.py mrp/2020/cl/companion/mrp_file --outdir mrp/2020/cl/companion/

# Augment raw data with companion
#for EDS and AMR
python toolkit/augment_data.py companion_file.conllu EDS_or_AMR_data.mrp output_augmented_EDS_or_AMR_data.mrp
#for UCCA
python toolkit/augment_data_conllu.py companion_file.conllu UCCA_data.mrp output_augmented_UCCA_data.mrp
