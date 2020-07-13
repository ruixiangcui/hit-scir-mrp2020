#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=2-0
#SBATCH -p gpu --gres=gpu:titanx:1


echo '######## converting mrp to amr ...' >&2
python3 utils/mrp_to_amr.py -i $1 -o $1.amr.txt --not_amr_str_only --all_nodes

export JAMR_HOME=./JAMR
export CDEC=./JAMR/tools/cdec

echo '######## running jamr rule based aligner ...' >&2
toolkit/scripts/ALIGN.sh < $1.amr.txt > $1.jalign.txt


echo '######## running tamr rule based aligner ...' >&2
python3 toolkit/tamr_aligner/rule_base_align.py -verbose -data $1.jalign.txt -output $1.alignment.txt -wordvec $2 -trials 10000 -improve_perfect -morpho_match -semantic_match

echo '######## refreshing alignments ...' >&2
python3 toolkit/tamr_aligner/refresh_alignments.py -lexicon $1.alignment.txt -data $1.jalign.txt > $1.new_aligned.txt

echo '######## generating oracles ...' >&2
python3 toolkit/tamr_aligner/eager_oracle.py -mod dump -aligned $1.new_aligned.txt > $1.actions.txt

echo '######## adding extra mrp information ...' >&2
python3 toolkit/amr_add_extra.py -i $1.actions.txt -o $1.actions.aug.txt -e mrp $1

