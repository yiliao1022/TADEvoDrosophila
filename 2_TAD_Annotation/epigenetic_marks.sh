
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


