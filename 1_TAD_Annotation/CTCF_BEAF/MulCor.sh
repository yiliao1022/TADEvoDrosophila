#!/bin/bash
#$ -N map_sub
#$ -q jje128
#####$ -m beas
#$ -pe openmp 1
#$ -t 1-100

module load anaconda/3.7-5.3.0
module load bedtools

num=$SGE_TASK_ID

perl permutationNarrow.pl Dpse_hicexplorer.boundaries.bed $num


