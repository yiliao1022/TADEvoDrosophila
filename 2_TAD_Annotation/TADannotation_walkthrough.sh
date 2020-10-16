
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
#the following command will do: fastq raw date processing, mapping, generating Hi-C maps, and output default 5kb TAD domains.
bash juicer.sh -g dpse -q jje128 -l jje128 -d /data/users/liaoy12/liaoy12/Pseudoobscura/HiC/3dDNA_NEW20190416 -s Arima -y /data/users/liaoy12/liaoy12/Pseudoobscura/HiC/3dDNA_NEW20190416/restriction_sites/dpse_combin.txt -p /data/users/liaoy12/liaoy12/Pseudoobscura/Contigs/FINAL/dpse.pilon.rnd3.fasta.sizes -z /data/users/liaoy12/liaoy12/Pseudoobscura/Contigs/FINAL/dpse.pilon.rnd3.fasta -t 120

3. Armatus
#construct 5kb resolution matrix using the original Juicer high resolution matrix
for i in Chr2 Chr3 Chr4 Chr5 XL XR; do java -jar /data/apps/juicer/1.5.6/scripts/juicer_tools.jar dump observed NONE /data/users/liaoy12/liaoy12/Pseudoobscura/HiC/3dDNA/aligned/inter_30.hic $i $i BP 5000 $i\_5K.matrix; done
#TAD calling
export LD_LIBRARY_PATH=/data/users/liaoy12/liaoy12/Software/lib/
for i in Chr2 Chr3 Chr4 Chr5 XL XR; do /data/users/liaoy12/liaoy12/Pseudoobscura/HiC/Armatus/armatus/binaries/armatus-v2.3-ubuntu-x86_64 -S -g 0.9 -c $i -r 5000 -s 0.1 -i $i\_5K.matrix -o $i\_5K; done 








