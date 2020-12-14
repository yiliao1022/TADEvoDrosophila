#!/bin/bash
#$ -N temp
#$ -q jje128
#$ -m beas

module load bedtools
export DEL=3p.del.bed
export INS=3p.NonTE.ins.bed
export TE=3p.TE.ins.bed
export CNV=3p.cnv.bed
#export CNVALL=3species.CNV.total.bed.bed.bed.euchromatin.bed

perl /data/users/liaoy12/liaoy12/TAD_SV/7_SV_TAD_2020Feb18/bin/permutation_deletions.pl 3p.cnv.bed.uniq.bed1_20k
#perl /data/users/liaoy12/liaoy12/TAD_SV/7_SV_TAD_2020Feb18/bin/permutation_deletions.pl $DEL.uniq.breakpionts.bed
#perl /data/users/liaoy12/liaoy12/TAD_SV/7_SV_TAD_2020Feb18/bin/permutation_deletions.pl $DEL.uniq.breakpionts.bed1_10bp
#perl /data/users/liaoy12/liaoy12/TAD_SV/7_SV_TAD_2020Feb18/bin/permutation_deletions.pl $DEL.uniq.breakpionts.bed11_2000bp
#perl /data/users/liaoy12/liaoy12/TAD_SV/7_SV_TAD_2020Feb18/bin/permutation_deletions.pl $DEL.uniq.breakpoints.bed_rare
#perl /data/users/liaoy12/liaoy12/TAD_SV/7_SV_TAD_2020Feb18/bin/permutation_deletions.pl $DEL.uniq.breakpoints.bed_common
#perl /data/users/liaoy12/liaoy12/TAD_SV/7_SV_TAD_2020Feb18/bin/permutation_deletions.pl $CNV.uniq.breakpoints.bed1_20k
#perl /data/users/liaoy12/liaoy12/TAD_SV/7_SV_TAD_2020Feb18/bin/permutation_deletions.pl $CNVALL.uniq.breakpoints.bed1_20k

#perl /data/users/liaoy12/liaoy12/TAD_SV/7_SV_TAD_2020Feb18/bin/permutation_insertions.pl $INS.uniq.bed
#perl /data/users/liaoy12/liaoy12/TAD_SV/7_SV_TAD_2020Feb18/bin/permutation_insertions.pl $INS.uniq.bed1_10bp
#perl /data/users/liaoy12/liaoy12/TAD_SV/7_SV_TAD_2020Feb18/bin/permutation_insertions.pl $INS.uniq.bed11_20kb
#perl /data/users/liaoy12/liaoy12/TAD_SV/7_SV_TAD_2020Feb18/bin/permutation_insertions.pl $INS.uniq.bed_rare
#perl /data/users/liaoy12/liaoy12/TAD_SV/7_SV_TAD_2020Feb18/bin/permutation_insertions.pl $INS.uniq.bed_common
#perl /data/users/liaoy12/liaoy12/TAD_SV/7_SV_TAD_2020Feb18/bin/permutation_insertions.pl TE.all.uniq.bed
#perl /data/users/liaoy12/liaoy12/TAD_SV/7_SV_TAD_2020Feb18/bin/permutation_insertions.pl TE.LINE.uniq.bed
#perl /data/users/liaoy12/liaoy12/TAD_SV/7_SV_TAD_2020Feb18/bin/permutation_insertions.pl TE.LTR.uniq.bed
#perl /data/users/liaoy12/liaoy12/TAD_SV/7_SV_TAD_2020Feb18/bin/permutation_insertions.pl TE.DNA.uniq.bed
