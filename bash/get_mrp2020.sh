#!/bin/bash

mkdir -p data

# Download mrp2020 data from https://drive.google.com/file/d/1llyl-agwFL7QwSk5kkFUSbbzF3ajBeNw/view | unzip and put in content root

#Convert augment data from mrp to conllu
python toolkit/mrp2conllu.py mrp/2020/cl/companion/mrp_file --outdir mrp/2020/cl/companion/

# Augment raw data with companion
python toolkit/augment_data.py companion_file.conllu mrp_file.mrp augmented_data.mrp
