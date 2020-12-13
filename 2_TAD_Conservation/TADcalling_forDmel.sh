# HiCExplorer


###Step1:  Download the dm6 genome and index

bwa index -a bwtsw dmel.chr.fasta 

###Step2:  Download Hi-C data from NCBI SRA

Kc167: SRX5014527 SRX5014528 
BG3: SRX5014529 SRX5014530
num=$SGE_TASK_ID ### num in 1-4
ID=$((num+26))
/data/users/liaoy12/Softwares/sratoolkit.2.9.2-centos_linux64/bin/fastq-dump.2.9.2 --split-files SRX50145${ID}

###Step3:  Mapping the Hi-C reads to dm6 genome
$NSLOTS  = 120-128
module load bwa/0.7.17-5g
module load samtools/1.9

bwa mem -t $NSLOTS -A1 -B4 -E50 -L0 /data/users/liaoy12/liaoy12/TAD/genomes/dmel.chr.fasta data/SRX5014527_1.fastq | samtools view -Shb - > mapped_files/SRX5014527_1.sam
bwa mem -t $NSLOTS -A1 -B4 -E50 -L0 /data/users/liaoy12/liaoy12/TAD/genomes/dmel.chr.fasta data/SRX5014527_2.fastq | samtools view -Shb - > mapped_files/SRX5014527_2.sam 
bwa mem -t $NSLOTS -A1 -B4 -E50 -L0 /data/users/liaoy12/liaoy12/TAD/genomes/dmel.chr.fasta data/SRX5014528_1.fastq | samtools view -Shb - > mapped_files/SRX5014528_1.sam  
bwa mem -t $NSLOTS -A1 -B4 -E50 -L0 /data/users/liaoy12/liaoy12/TAD/genomes/dmel.chr.fasta data/SRX5014528_2.fastq | samtools view -Shb - > mapped_files/SRX5014528_2.sam
bwa mem -t $NSLOTS -A1 -B4 -E50 -L0 /data/users/liaoy12/liaoy12/TAD/genomes/dmel.chr.fasta data/SRX5014529_1.fastq | samtools view -Shb - > mapped_files/SRX5014529_1.sam  
bwa mem -t $NSLOTS -A1 -B4 -E50 -L0 /data/users/liaoy12/liaoy12/TAD/genomes/dmel.chr.fasta data/SRX5014529_2.fastq | samtools view -Shb - > mapped_files/SRX5014529_2.sam
bwa mem -t $NSLOTS -A1 -B4 -E50 -L0 /data/users/liaoy12/liaoy12/TAD/genomes/dmel.chr.fasta data/SRX5014530_1.fastq | samtools view -Shb - > mapped_files/SRX5014530_1.sam  
bwa mem -t $NSLOTS -A1 -B4 -E50 -L0 /data/users/liaoy12/liaoy12/TAD/genomes/dmel.chr.fasta data/SRX5014530_2.fastq | samtools view -Shb - > mapped_files/SRX5014530_2.sam

###Step4: Generating DPNII restriction site bed file for dm6 genome
module load python/2.7.15
/data/users/liaoy12/liaoy12/Pseudoobscura/HiC/bin/HiC-Pro/bin/utils/digest_genome.py -r ^GATC -o dm6_dpnii.bed dmel.chr.fasta 

###Step5: Build Matrices DPNII for TADs
  ## 10kb
hicBuildMatrix --samFiles mapped_files/SRX5014527_1.sam mapped_files/SRX5014527_2.sam --restrictionSequence GATC --binSize 10000 --threads 8 --inputBufferSize 100000 --outBam SRX5014527_hic_10kb.bam -o hiCmatrix/SRX5014527_hic_matrix_10kb.h5 --QCfolder hiCmatrix/SRX5014527_hic_matrix_10kb_hicQC
hicBuildMatrix --samFiles mapped_files/SRX5014528_1.sam mapped_files/SRX5014528_2.sam --restrictionSequence GATC --binSize 10000 --threads 8 --inputBufferSize 100000 --outBam SRX5014528_hic_10kb.bam -o hiCmatrix/SRX5014528_hic_matrix_10kb.h5 --QCfolder hiCmatrix/SRX5014528_hic_matrix_10kb_hicQC 
hicBuildMatrix --samFiles mapped_files/SRX5014529_1.sam mapped_files/SRX5014529_2.sam --restrictionSequence GATC --binSize 10000 --threads 8 --inputBufferSize 100000 --outBam SRX5014529_hic_10kb.bam -o hiCmatrix/SRX5014529_hic_matrix_10kb.h5 --QCfolder hiCmatrix/SRX5014529_hic_matrix_10kb_hicQC
hicBuildMatrix --samFiles mapped_files/SRX5014530_1.sam mapped_files/SRX5014530_2.sam --restrictionSequence GATC --binSize 10000 --threads 8 --inputBufferSize 100000 --outBam SRX5014530_hic_10kb.bam -o hiCmatrix/SRX5014530_hic_matrix_10kb.h5 --QCfolder hiCmatrix/SRX5014530_hic_matrix_10kb_hicQC
  ## 150bp
hicBuildMatrix --samFiles mapped_files/SRX5014527_1.sam mapped_files/SRX5014527_2.sam --restrictionCutFile /data/users/liaoy12/liaoy12/TAD/genomes/dm6_dpnii.bed --minDistance 150 --threads 8 --inputBufferSize 100000 --outBam SRX5014527_hic_dpnII.bam -o hiCmatrix/SRX5014527_hic_matrix_dpnII.h5 --QCfolder hiCmatrix/SRX5014527_hic_matrix_dpnII_hicQC
hicBuildMatrix --samFiles mapped_files/SRX5014528_1.sam mapped_files/SRX5014528_2.sam --restrictionCutFile /data/users/liaoy12/liaoy12/TAD/genomes/dm6_dpnii.bed --minDistance 150 --threads 8 --inputBufferSize 100000 --outBam SRX5014528_hic_dpnII.bam -o hiCmatrix/SRX5014528_hic_matrix_dpnII.h5 --QCfolder hiCmatrix/SRX5014528_hic_matrix_dpnII_hicQC 
hicBuildMatrix --samFiles mapped_files/SRX5014529_1.sam mapped_files/SRX5014529_2.sam --restrictionCutFile /data/users/liaoy12/liaoy12/TAD/genomes/dm6_dpnii.bed --minDistance 150 --threads 8 --inputBufferSize 100000 --outBam SRX5014529_hic_dpnII.bam -o hiCmatrix/SRX5014529_hic_matrix_dpnII.h5 --QCfolder hiCmatrix/SRX5014529_hic_matrix_dpnII_hicQC
hicBuildMatrix --samFiles mapped_files/SRX5014530_1.sam mapped_files/SRX5014530_2.sam --restrictionCutFile /data/users/liaoy12/liaoy12/TAD/genomes/dm6_dpnii.bed --minDistance 150 --threads 8 --inputBufferSize 100000 --outBam SRX5014530_hic_dpnII.bam -o hiCmatrix/SRX5014530_hic_matrix_dpnII.h5 --QCfolder hiCmatrix/SRX5014530_hic_matrix_dpnII_hicQC
  ## 100kb
hicBuildMatrix --samFiles mapped_files/SRX5014527_1.sam mapped_files/SRX5014527_2.sam --restrictionSequence GATC --binSize 100000 --threads 8 --inputBufferSize 100000 --outBam SRX5014527_hic_100kb.bam -o hiCmatrix/SRX5014527_hic_matrix_100kb.h5 --QCfolder hiCmatrix/SRX5014527_hic_matrix_100kb_hicQC
hicBuildMatrix --samFiles mapped_files/SRX5014528_1.sam mapped_files/SRX5014528_2.sam --restrictionSequence GATC --binSize 100000 --threads 8 --inputBufferSize 100000 --outBam SRX5014528_hic_100kb.bam -o hiCmatrix/SRX5014528_hic_matrix_100kb.h5 --QCfolder hiCmatrix/SRX5014528_hic_matrix_100kb_hicQC 
hicBuildMatrix --samFiles mapped_files/SRX5014529_1.sam mapped_files/SRX5014529_2.sam --restrictionSequence GATC --binSize 100000 --threads 8 --inputBufferSize 100000 --outBam SRX5014529_hic_100kb.bam -o hiCmatrix/SRX5014529_hic_matrix_100kb.h5 --QCfolder hiCmatrix/SRX5014529_hic_matrix_100kb_hicQC
hicBuildMatrix --samFiles mapped_files/SRX5014530_1.sam mapped_files/SRX5014530_2.sam --restrictionSequence GATC --binSize 100000 --threads 8 --inputBufferSize 100000 --outBam SRX5014530_hic_100kb.bam -o hiCmatrix/SRX5014530_hic_matrix_100kb.h5 --QCfolder hiCmatrix/SRX5014530_hic_matrix_100kb_hicQC

###Step6: Merge, diagnose, and correct the Matrices

hicSumMatrices -m hiCmatrix/SRX5014527_hic_matrix_dpnII.h5 hiCmatrix/SRX5014528_hic_matrix_dpnII.h5 -o hiCmatrix/Kc167_hic_matrix_dpnII.h5
hicSumMatrices -m hiCmatrix/SRX5014527_hic_matrix_10kb.h5 hiCmatrix/SRX5014528_hic_matrix_10kb.h5 -o hiCmatrix/Kc167_hic_matrix_10kb.h5
hicSumMatrices -m hiCmatrix/SRX5014527_hic_matrix_100kb.h5 hiCmatrix/SRX5014528_hic_matrix_100kb.h5 -o hiCmatrix/Kc167_hic_matrix_100kb.h5
hicSumMatrices -m hiCmatrix/SRX5014529_hic_matrix_dpnII.h5 hiCmatrix/SRX5014530_hic_matrix_dpnII.h5 -o hiCmatrix/BG3_hic_matrix_dpnII.h5
hicSumMatrices -m hiCmatrix/SRX5014529_hic_matrix_10kb.h5 hiCmatrix/SRX5014530_hic_matrix_10kb.h5 -o hiCmatrix/BG3_hic_matrix_10kb.h5
hicSumMatrices -m hiCmatrix/SRX5014529_hic_matrix_100kb.h5 hiCmatrix/SRX5014530_hic_matrix_100kb.h5 -o hiCmatrix/BG3_hic_matrix_100kb.h5

hicCorrectMatrix diagnostic_plot -m hiCmatrix/Kc167_hic_matrix_dpnII.h5 -o plots/Kc167_hic_matrix_dpnII_plot.png
hicCorrectMatrix diagnostic_plot -m hiCmatrix/BG3_hic_matrix_dpnII.h5 -o plots/BG3_hic_matrix_dpnII_plot.png
hicCorrectMatrix diagnostic_plot -m hiCmatrix/Kc167_hic_matrix_10kb.h5 -o plots/Kc167_hic_matrix_10kb_plot.png
hicCorrectMatrix diagnostic_plot -m hiCmatrix/BG3_hic_matrix_10kb.h5 -o plots/BG3_hic_matrix_10kb_plot.png
hicCorrectMatrix diagnostic_plot -m hiCmatrix/Kc167_hic_matrix_100kb.h5 -o plots/Kc167_hic_matrix_100kb_plot.png
hicCorrectMatrix diagnostic_plot -m hiCmatrix/BG3_hic_matrix_100kb.h5 -o plots/BG3_hic_matrix_100kb_plot.png

hicCorrectMatrix correct --filterThreshold -1.4 5 -m hiCmatrix/Kc167_hic_matrix_dpnII.h5 -o hiCmatrix/Kc167_hic_matrix_dpnII_corrected.h5
hicCorrectMatrix correct --filterThreshold -1.4 5 -m hiCmatrix/Kc167_hic_matrix_10kb.h5 -o hiCmatrix/Kc167_hic_matrix_10kb_corrected.h5
hicCorrectMatrix correct --filterThreshold -1.4 5 -m hiCmatrix/Kc167_hic_matrix_100kb.h5 -o hiCmatrix/Kc167_hic_matrix_100kb_corrected.h5
hicCorrectMatrix correct --filterThreshold -1.4 5 -m hiCmatrix/BG3_hic_matrix_dpnII.h5 -o hiCmatrix/BG3_hic_matrix_dpnII_corrected.h5
hicCorrectMatrix correct --filterThreshold -1.4 5 -m hiCmatrix/BG3_hic_matrix_10kb.h5 -o hiCmatrix/BG3_hic_matrix_10kb_corrected.h5
hicCorrectMatrix correct --filterThreshold -1.4 5 -m hiCmatrix/BG3_hic_matrix_100kb.h5 -o hiCmatrix/BG3_hic_matrix_100kb_corrected.h5

###Step7: Call TADs

hicFindTADs -m hiCmatrix/Kc167_hic_matrix_dpnII_corrected.h5 --outPrefix TADs/Kc167_hic_matrix_dpnII_corrected_step4000_0.04 --correctForMultipleTesting fdr --numberOfProcessors 30 --minBoundaryDistance 5000 --thresholdComparisons 0.01 --delta 0.04 --step 4000 
hicFindTADs -m hiCmatrix/Kc167_hic_matrix_dpnII_corrected.h5 --outPrefix TADs/Kc167_hic_matrix_dpnII_corrected_step4000_0.08 --correctForMultipleTesting fdr --numberOfProcessors 30 --minBoundaryDistance 5000 --thresholdComparisons 0.01 --delta 0.08 --step 4000
hicFindTADs -m hiCmatrix/BG3_hic_matrix_dpnII_corrected.h5 --outPrefix TADs/BG3_hic_matrix_dpnII_corrected_step4000_0.04 --correctForMultipleTesting fdr --numberOfProcessors 30 --minBoundaryDistance 5000 --thresholdComparisons 0.01 --delta 0.04 --step 4000
hicFindTADs -m hiCmatrix/BG3_hic_matrix_dpnII_corrected.h5 --outPrefix TADs/BG3_hic_matrix_dpnII_corrected_step4000_0.08 --correctForMultipleTesting fdr --numberOfProcessors 30 --minBoundaryDistance 5000 --thresholdComparisons 0.01 --delta 0.08 --step 4000


# 3dDNA plus A

### Step1: Generate Hi-C contact matric
  ## generate restriction sites file
~/3dDNA/bin/generate_site_positions.py DpnII dmel /data/users/liaoy12/liaoy12/TAD/genomes/dmel.chr.fasta 
  ## Align reads with 3dDNA pipeline
mkdir 3dDNA
cd 3dDNA
module load bwa/0.7.17-5g
module load juicer
mkdir Kc167
cd Kc167
bash juicer.sh -g dmel -q jje128 -l jje128 -d /data/users/liaoy12/liaoy12/TAD/CallTAD/jucier/Kc167 -s DpnII -y /data/users/liaoy12/liaoy12/TAD/genomes/dmel_DpnII.txt -p /data/users/liaoy12/liaoy12/TAD/genomes/dmel.chr.fasta.sizes -z /data/users/liaoy12/liaoy12/TAD/genomes/dmel.chr.fasta -t 120
cd ..
mkdir BG3
cd BG3
bash juicer.sh -g dmel -q jje128 -l jje128 -d /data/users/liaoy12/liaoy12/TAD/CallTAD/jucier/BG3 -s DpnII -y /data/users/liaoy12/liaoy12/TAD/genomes/dmel_DpnII.txt -p /data/users/liaoy12/liaoy12/TAD/genomes/dmel.chr.fasta.sizes -z /data/users/liaoy12/liaoy12/TAD/genomes/dmel.chr.fasta -t 120
cd ../../


 ## For Kc167
mkidr Armatus
cd Armatus
mkdir Kc167
cd Kc167
ln -s ../../Kc167/aligned/inter.hic dmel.Kc167.hic

java -jar /data/apps/juicer/1.5.6/scripts/juicer_tools.jar dump observed NONE Dmel.Kc167.hic 2L 2L BP 10000 2L_10k.matrix
java -jar /data/apps/juicer/1.5.6/scripts/juicer_tools.jar dump observed NONE Dmel.Kc167.hic 2R 2R BP 10000 2R_10k.matrix
java -jar /data/apps/juicer/1.5.6/scripts/juicer_tools.jar dump observed NONE Dmel.Kc167.hic 3L 3L BP 10000 3L_10k.matrix
java -jar /data/apps/juicer/1.5.6/scripts/juicer_tools.jar dump observed NONE Dmel.Kc167.hic 3R 3R BP 10000 3R_10k.matrix
java -jar /data/apps/juicer/1.5.6/scripts/juicer_tools.jar dump observed NONE Dmel.Kc167.hic 4 4 BP 10000 4_10k.matrix
java -jar /data/apps/juicer/1.5.6/scripts/juicer_tools.jar dump observed NONE Dmel.Kc167.hic X X BP 10000 X_10k.matrix
  ## For BG3
cd ../
mkdir BG3
cd BG3
ln -s ../../BG3/aligned/inter.hic dmel.BG3.hic
java -jar /data/apps/juicer/1.5.6/scripts/juicer_tools.jar dump observed NONE Dmel.BG3.hic 2L 2L BP 10000 2L_10k.matrix
java -jar /data/apps/juicer/1.5.6/scripts/juicer_tools.jar dump observed NONE Dmel.BG3.hic 2R 2R BP 10000 2R_10k.matrix
java -jar /data/apps/juicer/1.5.6/scripts/juicer_tools.jar dump observed NONE Dmel.BG3.hic 3L 3L BP 10000 3L_10k.matrix
java -jar /data/apps/juicer/1.5.6/scripts/juicer_tools.jar dump observed NONE Dmel.BG3.hic 3R 3R BP 10000 3R_10k.matrix
java -jar /data/apps/juicer/1.5.6/scripts/juicer_tools.jar dump observed NONE Dmel.BG3.hic 4 4 BP 10000 4_10k.matrix
java -jar /data/apps/juicer/1.5.6/scripts/juicer_tools.jar dump observed NONE Dmel.BG3.hic X X BP 10000 X_10k.matrix


### Step2: Call TAD with Armatus
  ## For Kc167
cd Armatus
cd Kc167
export LD_LIBRARY_PATH=/data/users/liaoy12/liaoy12/Software/lib/

INPUT1=/data/users/liaoy12/liaoy12/TAD/CallTAD/jucier/Armatus/Kc167/2L_10k.matrix
INPUT2=/data/users/liaoy12/liaoy12/TAD/CallTAD/jucier/Armatus/Kc167/2R_10k.matrix
INPUT3=/data/users/liaoy12/liaoy12/TAD/CallTAD/jucier/Armatus/Kc167/3L_10k.matrix
INPUT4=/data/users/liaoy12/liaoy12/TAD/CallTAD/jucier/Armatus/Kc167/3R_10k.matrix
INPUT5=/data/users/liaoy12/liaoy12/TAD/CallTAD/jucier/Armatus/Kc167/X_10k.matrix
INPUT6=/data/users/liaoy12/liaoy12/TAD/CallTAD/jucier/Armatus/Kc167/4_10k.matrix

~/Softwares/Armatus-latest_ubuntu-12.04/bin/armatus -m -r 10000 -S -c 2L -i $INPUT1 -g 1.0 -s 0.05 -o 2L_10k
~/Softwares/Armatus-latest_ubuntu-12.04/bin/armatus -m -r 10000 -S -c 2R -i $INPUT2 -g 1.0 -s 0.05 -o 2R_10k
~/Softwares/Armatus-latest_ubuntu-12.04/bin/armatus -m -r 10000 -S -c 3L -i $INPUT3 -g 1.0 -s 0.05 -o 3L_10k
~/Softwares/Armatus-latest_ubuntu-12.04/bin/armatus -m -r 10000 -S -c 3R -i $INPUT4 -g 1.0 -s 0.05 -o 3R_10k
~/Softwares/Armatus-latest_ubuntu-12.04/bin/armatus -m -r 10000 -S -c X -i $INPUT5 -g 1.0 -s 0.05 -o X_10k
~/Softwares/Armatus-latest_ubuntu-12.04/bin/armatus -m -r 10000 -S -c 4 -i $INPUT6 -g 1.0 -s 0.05 -o 4_10k

### For BG3
cd Armatus
cd BG3
export LD_LIBRARY_PATH=/data/users/liaoy12/liaoy12/Software/lib/

INPUT1=/data/users/liaoy12/liaoy12/TAD/CallTAD/jucier/Armatus/BG3/2L_10k.matrix
INPUT2=/data/users/liaoy12/liaoy12/TAD/CallTAD/jucier/Armatus/BG3/2R_10k.matrix
INPUT3=/data/users/liaoy12/liaoy12/TAD/CallTAD/jucier/Armatus/BG3/3L_10k.matrix
INPUT4=/data/users/liaoy12/liaoy12/TAD/CallTAD/jucier/Armatus/BG3/3R_10k.matrix
INPUT5=/data/users/liaoy12/liaoy12/TAD/CallTAD/jucier/Armatus/BG3/X_10k.matrix
INPUT6=/data/users/liaoy12/liaoy12/TAD/CallTAD/jucier/Armatus/BG3/4_10k.matrix

~/Softwares/Armatus-latest_ubuntu-12.04/bin/armatus -m -r 10000 -S -c 2L -i $INPUT1 -g 1.0 -s 0.05 -o 2L_10k
~/Softwares/Armatus-latest_ubuntu-12.04/bin/armatus -m -r 10000 -S -c 2R -i $INPUT2 -g 1.0 -s 0.05 -o 2R_10k
~/Softwares/Armatus-latest_ubuntu-12.04/bin/armatus -m -r 10000 -S -c 3L -i $INPUT3 -g 1.0 -s 0.05 -o 3L_10k
~/Softwares/Armatus-latest_ubuntu-12.04/bin/armatus -m -r 10000 -S -c 3R -i $INPUT4 -g 1.0 -s 0.05 -o 3R_10k
~/Softwares/Armatus-latest_ubuntu-12.04/bin/armatus -m -r 10000 -S -c X -i $INPUT5 -g 1.0 -s 0.05 -o X_10k
~/Softwares/Armatus-latest_ubuntu-12.04/bin/armatus -m -r 10000 -S -c 4 -i $INPUT6 -g 1.0 -s 0.05 -o 4_10k
