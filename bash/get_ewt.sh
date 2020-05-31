#!/bin/bash

mkdir -p data

# Download parsed companion data from http://svn.nlpl.eu/mrp/2019/public/companion.tgz and extract
wget -qO- http://svn.nlpl.eu/mrp/2019/public/companion.tgz?p=28375 | tar xvz
cat mrp/2019/companion/ucca/ewt0*.conllu > data/ewt.companion.conllu

# Get STREUSLE gold data
git clone https://github.com/nert-nlp/streusle -b v4.3 data/streusle

# Get UCCA gold data MRP
wget -qO- http://svn.nlpl.eu/mrp/2019/public/ucca.tgz?p=28375 | tar xvz

# Augment data
python toolkit/augment_data_conllu.py data/ewt.companion.conllu mrp/2019/training/ucca/ewt.mrp data/ewt.aug.companion.mrp
python toolkit/augment_data_conllulex.py data/streusle/streusle.conllulex mrp/2019/training/ucca/ewt.mrp data/ewt.aug.streusle.mrp

# Split augmented data to train/dev/test
for split in train dev test; do
  for suffix in companion streusle; do
    grep -Ff file-lists/$split.txt data/ewt.aug.$suffix.mrp > data/ewt.$split.aug.$suffix.mrp
  done
done

# Get UCCA gold data MRP XML
git clone https://github.com/UniversalConceptualCognitiveAnnotation/UCCA_English-EWT -b v1.0-sentences data/ewt
mkdir -p data/ewt/{train,dev,test}
for split in train dev test; do
  xargs -I % find data/ewt -maxdepth 1 -name '%*.pickle' < file-lists/$split.txt | xargs ln -srt data/ewt/$split
done

# Get mtool
git clone https://github.com/ruixiangcui/mtool -b 2019 toolkit/mtool
