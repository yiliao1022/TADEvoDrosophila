
# TAD annotation for D. pseudoobscura

1. HiCExplorer
(1) Mapping HiC reads to Dpse genome
num=$SGE_TASK_ID
module load bwa/0.7.17-5g
module load samtools/1.9
export REF=/data/users/liaoy12/liaoy12/Pseudoobscura/Contigs/FINAL/dpse.pilon.rnd3.fasta
bwa mem -t $NSLOTS -A1 -B4 -E50 -L0 $REF /data/users/liaoy12/liaoy12/Pseudoobscura/HiC/3dDNA/splits/JJE3_USPD16095657_HWMVKCCXY_L2_1.clean_R1.fastq00${num}.fastq 2>>mate_${sum}_R1.log | samtools view -Shb - > mate_${num}_R1.bam
bwa mem -t $NSLOTS -A1 -B4 -E50 -L0 $REF /data/users/liaoy12/liaoy12/Pseudoobscura/HiC/3dDNA/splits/JJE3_USPD16095657_HWMVKCCXY_L2_1.clean_R2.fastq00${num}.fastq 2>>mate_${num}_R2.log | samtools view -Shb - > mate_${num}_R2.bam
(2) hicBuileMatrix for different resolution
hicBuildMatrix --samFiles /data/users/liaoy12/liaoy12/Pseudoobscura/HiC/mapping/mate_R1.bam /data/users/liaoy12/liaoy12/Pseudoobscura/HiC/mapping/mate_R2.bam --restrictionCutFile /data/users/liaoy12/liaoy12/Pseudoobscura/HiC/ref/DpseHiC.bed --threads 8 --inputBufferSize 100000 --outBam hic.bam -o hic_matrix.h5 --QCfolder ./hicQC
hicBuildMatrix --samFiles /data/users/liaoy12/liaoy12/Pseudoobscura/HiC/mapping/mate_R1.bam /data/users/liaoy12/liaoy12/Pseudoobscura/HiC/mapping/mate_R2.bam --binSize 5000 --inputBufferSize 100000 --threads $NSLOTS -o hiCmatrix/Dpse_hic_matrix_5kb.h5 --QCfolder hiCmatrix/Dpse_hic_matrix_5kb_hicQC
hicBuildMatrix --samFiles /data/users/liaoy12/liaoy12/Pseudoobscura/HiC/mapping/mate_R1.bam /data/users/liaoy12/liaoy12/Pseudoobscura/HiC/mapping/mate_R2.bam --binSize 10000 --inputBufferSize 100000 --threads $NSLOTS --outBam Dpse_hic_10kb.bam -o hiCmatrix/Dpse_hic_matrix_10kb.h5 --QCfolder hiCmatrix/Dpse_hic_matrix_10kb_hicQ
hicBuildMatrix --samFiles /data/users/liaoy12/liaoy12/Pseudoobscura/HiC/mapping/mate_R1.bam /data/users/liaoy12/liaoy12/Pseudoobscura/HiC/mapping/mate_R2.bam --binSize 20000 --inputBufferSize 100000 --threads $NSLOTS -o hiCmatrix/Dpse_hic_matrix_20kb.h5 --QCfolder hiCmatrix/Dpse_hic_matrix_20kb_hicQC
(3) hicCorrectMatrix
for each resolution correct the Matrix using the command:
hicCorrectMatrix correct -m ../hicBuildMatrix/hic_matrix.h5 --filterThreshold -0.89 5 -o hic_corrected.h5
(4) hicFindTADs
TAD calling using 5kb resolution Matrix 
hicFindTADs -m ../Dpse_hic_matrix_5kb.h5  --correctForMultipleTesting fdr --outPrefix HiCmatrix_minBouDis20Kb_step2000_thres0.001_delta0.18_resolution.fdr --thresholdComparisons 0.001 --delta 0.18 --minBoundaryDistance 20000 --numberOfProcessors $NSLOTS
hicFindTADs -m ../Dpse_hic_matrix_5kb.h5  --correctForMultipleTesting fdr --outPrefix HiCmatrix_minBouDis20Kb_step2000_thres0.001_delta0.04_resolution.fdr --thresholdComparisons 0.001 --delta 0.04 --minBoundaryDistance 20000 --numberOfProcessors $NSLOTS
hicFindTADs -m ../Dpse_hic_matrix_5kb.h5  --correctForMultipleTesting fdr --outPrefix HiCmatrix_minBouDis20Kb_step2000_thres0.001_delta0.16_resolution.fdr --thresholdComparisons 0.001 --delta 0.16 --minBoundaryDistance 20000 --numberOfProcessors $NSLOTS
hicFindTADs -m ../Dpse_hic_matrix_5kb.h5  --correctForMultipleTesting fdr --outPrefix HiCmatrix_minBouDis20Kb_step2000_thres0.001_delta0.01_resolution.fdr --thresholdComparisons 0.001 --delta 0.01 --minBoundaryDistance 20000 --numberOfProcessors $NSLOTS

2. Arrowhead from the Juicer package
module load bwa
module load juicer
bwa index /data/users/liaoy12/liaoy12/Pseudoobscura/Contigs/FINAL/dpse.pilon.rnd3.fasta
#the following command will finish: fastq raw date processing, mapping, generating Hi-C maps, and output default 5kb TAD domains.
bash juicer.sh -g dpse -q jje128 -l jje128 -d /data/users/liaoy12/liaoy12/Pseudoobscura/HiC/3dDNA_NEW20190416 -s Arima -y /data/users/liaoy12/liaoy12/Pseudoobscura/HiC/3dDNA_NEW20190416/restriction_sites/dpse_combin.txt -p /data/users/liaoy12/liaoy12/Pseudoobscura/Contigs/FINAL/dpse.pilon.rnd3.fasta.sizes -z /data/users/liaoy12/liaoy12/Pseudoobscura/Contigs/FINAL/dpse.pilon.rnd3.fasta -t 120

3. Armatus
#construct 5kb resolution matrix using the original Juicer high resolution matrix
for i in Chr2 Chr3 Chr4 Chr5 XL XR; do java -jar /data/apps/juicer/1.5.6/scripts/juicer_tools.jar dump observed NONE /data/users/liaoy12/liaoy12/Pseudoobscura/HiC/3dDNA/aligned/inter_30.hic $i $i BP 5000 $i\_5K.matrix; done
#TAD calling
export LD_LIBRARY_PATH=/data/users/liaoy12/liaoy12/Software/lib/
for i in Chr2 Chr3 Chr4 Chr5 XL XR; do /data/users/liaoy12/liaoy12/Pseudoobscura/HiC/Armatus/armatus/binaries/armatus-v2.3-ubuntu-x86_64 -S -g 0.9 -c $i -r 5000 -s 0.1 -i $i\_5K.matrix -o $i\_5K; done 








CTCF
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


