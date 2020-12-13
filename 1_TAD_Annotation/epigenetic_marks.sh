
(1) CTCF

Download
/data/users/liaoy12/Softwares/sratoolkit.2.9.2-centos_linux64/bin/fastq-dump.2.9.2 --split-3 --gzip SRR066846
/data/users/liaoy12/Softwares/sratoolkit.2.9.2-centos_linux64/bin/fastq-dump.2.9.2 --split-3 --gzip SRR066849

Mapping
module load bowtie2/2.2.7 
module load samtools
export REF=/data/users/liaoy12/liaoy12/Pseudoobscura/ChIP/CTCF/Dpseudo_PacBioV2_genomic.fasta
export FQ1=/data/users/liaoy12/liaoy12/Data/Dpseu/CHIP_seq/CTCF/SRR066846.fastq.gz
export FQ2=/data/users/liaoy12/liaoy12/Data/Dpseu/CHIP_seq/CTCF/SRR066849.fastq.gz
bowtie2-build $REF dpse
bowtie2 -x dpse -U $FQ1 -D 20 -R 3 -N 0 -L 20 -i S,1,0.50 -S $FQ1.sam
bowtie2 -x dpse -U $FQ2 -D 20 -R 3 -N 0 -L 20 -i S,1,0.50 -S $FQ2.sam
samtools view -bS $FQ1.sam > $FQ1.bam
samtools view -bS $FQ2.sam > $FQ2.bam
samtools sort -@ 48 $FQ1.bam -o $FQ1.sorted.bam
samtools sort -@ 48 $FQ2.bam -o $FQ2.sorted.bam
for number in {1..2};
    do samtools index $FQ${number}.sorted.bam;
done;

Peak calling
module load macs2/2.0.10
macs2 callpeak -t CTCF.bam -c input.bam -f BAM -g 1.5e8 -n CTCF -q 0.01

Calculating the distribution of binding sites within 40kb around the TAD boundaries at 1kb window
perl ChIPoverlapTAD.pl Dpse_hicexplorer.domains.bed CTCF.peaks.list > HiCExploer.CTCF.list
perl SumDistribution.pl HiCExploer.CTCF.listt > HiCExplorer.CTCF.final.list

The custom scripts are available at

Enrichment analysis



(2) H3K4me3 and H3K27me3
  1. Mapping
module load bowtie2/2.2.7 
module load samtools

export FQ1=/data/users/liaoy12/liaoy12/Data/Dpseu/CHIP_seq/H3K27me3/SRR1552256.fastq.gz
export FQ2=/data/users/liaoy12/liaoy12/Data/Dpseu/CHIP_seq/H3K27me3/SRR1552260.fastq.gz
export FQ3=/data/users/liaoy12/liaoy12/Data/Dpseu/CHIP_seq/H3K27me3/SRR1552261.fastq.gz
export FQ4=/data/users/liaoy12/liaoy12/Data/Dpseu/CHIP_seq/H3K27me3/SRR1552273.fastq.gz
export FQ5=/data/users/liaoy12/liaoy12/Data/Dpseu/CHIP_seq/H3K27me3/SRR1552277.fastq.gz
export FQ6=/data/users/liaoy12/liaoy12/Data/Dpseu/CHIP_seq/H3K27me3/SRR1552278.fastq.gz

bowtie2 -x dpse -U $FQ1 -D 20 -R 3 -N 0 -L 20 -i S,1,0.50 -S $FQ1.sam
bowtie2 -x dpse -U $FQ2 -D 20 -R 3 -N 0 -L 20 -i S,1,0.50 -S $FQ2.sam
bowtie2 -x dpse -U $FQ3 -D 20 -R 3 -N 0 -L 20 -i S,1,0.50 -S $FQ3.sam
bowtie2 -x dpse -U $FQ4 -D 20 -R 3 -N 0 -L 20 -i S,1,0.50 -S $FQ4.sam
bowtie2 -x dpse -U $FQ5 -D 20 -R 3 -N 0 -L 20 -i S,1,0.50 -S $FQ5.sam
bowtie2 -x dpse -U $FQ6 -D 20 -R 3 -N 0 -L 20 -i S,1,0.50 -S $FQ6.sam

samtools view -bS $FQ1.sam > $FQ1.bam
samtools view -bS $FQ2.sam > $FQ2.bam
samtools view -bS $FQ3.sam > $FQ3.bam
samtools view -bS $FQ4.sam > $FQ4.bam
samtools view -bS $FQ5.sam > $FQ5.bam
samtools view -bS $FQ6.sam > $FQ6.bam

samtools sort -@ $NSLOTS $FQ1.bam -o $FQ1.sorted.bam
samtools sort -@ $NSLOTS $FQ2.bam -o $FQ2.sorted.bam
samtools sort -@ $NSLOTS $FQ3.bam -o $FQ3.sorted.bam
samtools sort -@ $NSLOTS $FQ4.bam -o $FQ4.sorted.bam
samtools sort -@ $NSLOTS $FQ5.bam -o $FQ5.sorted.bam
samtools sort -@ $NSLOTS $FQ6.bam -o $FQ6.sorted.bam

samtools index $FQ1.sorted.bam
samtools index $FQ2.sorted.bam
samtools index $FQ3.sorted.bam
samtools index $FQ4.sorted.bam
samtools index $FQ5.sorted.bam
samtools index $FQ6.sorted.bam

samtools merge H3K27me3.merge.bam SRR1552256.fastq.gz.sorted.bam SRR1552273.fastq.gz.sorted.bam
samtools merge H3K4.merge.bam SRR1552260.fastq.gz.sorted.bam SRR1552277.fastq.gz.sorted.bam
samtools merge input.merge.bam SRR1552278.fastq.gz.sorted.bam SRR1552261.fastq.gz.sorted.bam

samtools sort -@ $NSLOTS H3K27me3.merge.bam -o H3K27me3.merge.sorted.bam
samtools sort -@ $NSLOTS H3K4.merge.bam -o H3K4.merge.sorted.bam
samtools sort -@ $NSLOTS input.merge.bam -o input.merge.sorted.bam

samtools index H3K27me3.merge.sorted.bam
samtools index H3K4.merge.sorted.bam
samtools indext input.merge.sorted.bam

 2. Tobigwig file
bamCompare -b1 H3K4.merge.sorted.bam -b2 input.merge.sorted.bam --binSize 10 --operation log2 --minMappingQuality 30 --skipNonCoveredRegions --ignoreDupli
cates --numberOfProcessors $NSLOTS -o H3K4.bed -of bedgraph

bamCompare -b1 H3K27.merge.sorted.bam -b2 input.merge.sorted.bam --binSize 10 --operation log2 --minMappingQuality 30 --skipNonCoveredRegions --ignoreDupli
cates --numberOfProcessors $NSLOTS -o H3K27me3.bed -of bedgraph

faSize -detailed /data/users/liaoy12/liaoy12/Pseudoobscura/ChIP/CTCF/Dpseudo_PacBioV2_genomic.fasta > Dpse.sizes
cat H3K4.bed | grep -v tig > H3K4.chr.bed
cat H3K27me3.bed | grep -v tig > H3K27.chr.bed
/data/apps/enthought_python/7.3.2/bin/bedGraphToBigWig H3K4.chr.bed Dpse.sizes H3K4.NEW.bw
/data/apps/enthought_python/7.3.2/bin/bedGraphToBigWig H3K27.chr.bed Dpse.sizes H3K27.NEW.bw

 3. Enrichment analysis and permulation

#!/bin/bash
#$ -N map_sub
#$ -q jje128
#$ -pe openmp 1
#$ -t 1-100

module load anaconda/3.7-5.3.0
module load bedtools
num=$SGE_TASK_ID

perl permutation.pl Dpse_hicexplorer.boundaries.bed $num

