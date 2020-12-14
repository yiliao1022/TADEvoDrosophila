
cd ~
mkdir TAD
cd TAD
mkdir genomes
cd genomes
cp ../../RepeatMasker/*.masked ./

######### Step 2: reformat the chromosome IDs in each masked fasta file
   ####1 for reference dmel
iTools Fatools reform -InPut dmel-all-chromosome-r6.28.fasta.masked -NOcomment -OutPut dmel.fa
gunzip dmel.fa.gz
iTools Fatools getSP -InFa dmel.fa -UnPattern 211 -OutPut dmel.fasta
gunizp dmel.fasta.gz
rm dmel.fa
iTools Fatools getSP -InFa dmel.fasta -UnPattern Scaffold -OutPut dmel.chr.fasta
gunzip dmel.chr.fasta.gz
rm dmel.fasta
iTools Fatools getSP -InFa dmel.chr.fasta -UnPattern rDNA -OutPut dmel.chr.fa
gunzip dmel.chr.fa
rm dmel.chr.fasta
   ####

for i in `ls *.masked`;
do iTools Fatools getSP -InFa $i -Pattern CM -OutPut $i.fasta;  ## Only keep the chromosome sequences, small contigs are excluded for further processing
done;
gunzip *.gz
rm *.masked

perl reformatID.pl GCA_003397115.2_ASM339711v2_genomic.fna.masked.fasta B6
perl reformatID.pl GCA_003401685.1_ASM340168v1_genomic.fna.masked.fasta AB8
perl reformatID.pl GCA_003401805.1_ASM340180v1_genomic.fna.masked.fasta A2
perl reformatID.pl GCA_003401975.1_ASM340197v1_genomic.fna.masked.fasta B2
perl reformatID.pl GCA_003401885.1_ASM340188v1_genomic.fna.masked.fasta A6
perl reformatID.pl GCA_003401855.1_ASM340185v1_genomic.fna.masked.fasta A5
perl reformatID.pl GCA_003402005.1_ASM340200v1_genomic.fna.masked.fasta B4
perl reformatID.pl GCA_003402055.1_ASM340205v1_genomic.fna.masked.fasta B3

############Step 3: Whole genome alignment with Lastz

cd ..
mkdir Lastz

for i in A2 A5 A6 AB8 B2 B3 B4 B6; do mkdir $i; done
   #for i in A2 A5 A6 AB8 B2 B3 B4 B6; do cp conf ./$i; done
   #for i in A2 A5 A6 AB8 B2 B3 B4 B6; do cp Lastz.sh ./$i; done

  # run other assemblies manually like this
cd A2 
/data/users/liaoy12/Softwares/parallelLastz.pl --qfile /data/users/liaoy12/liaoy12/TAD/genomes/dmel.chr.fasta --tfile /data/users/liaoy12/liaoy12/TAD/genomes/A2.fa --cfile conf --speedup 8 --length 100                                               
 
 ##########Step 4: Chain/Net/Synnet

#### Run each chromosome separately
#!/bin/bash
#$ -N ChainNet
#$ -q jje128
#$ -m beas

module load jje/kent/2014.02.19
export REF=/data/users/liaoy12/liaoy12/SV2020/Drosophila/genomes/ISO1


for i in A1 A2 A3 A4 A5 A6 A7 AB8 B1 B2 B3 B4 B6 ORE Dere Dmau Dyak Dsec Dsim; do 
#for i in Dmau Dsec Dsim; do

export Sam=/data/users/liaoy12/liaoy12/SV2020/Drosophila/genomes/$i

for j in ./ISO2_$i\_ISO1.2L.lz; do 

axtChain -linearGap=/share/jje/liaoy12/Date/paras/medium $j $REF.2bit $Sam.2bit $j.chain

chainPreNet $j.chain $REF.sizes $Sam.sizes $j.chain.filter

chainNet -minSpace=1 $j.chain.filter $REF.sizes $Sam.sizes $j.chain.filter.tnet $j.chain.filter.qnet

netSyntenic $j.chain.filter.tnet $j.chain.filter.tnet.synnet

perl ../../../../SVsFromGenomes/SynnetFilter.pl $j.chain.filter.tnet.synnet

netToAxt $j.chain.filter.tnet.synnet.filter $j.chain.filter $REF.2bit $Sam.2bit $j.chain.filter.tnet.synnet.axt

axtToMaf $j.chain.filter.tnet.synnet.axt $REF.sizes $Sam.sizes $j.chain.filter.tnet.synnet.axt.maf

single_cov2 $j.chain.filter.tnet.synnet.axt.maf > ISO1.$i.sing.maf;done

#rm $j.chain $j.chain.filter $j.chain.filter.tnet $j.chain.filter.qnet $j.chain.filter.tnet.synnet.axt $j.chain.filter.tnet.synnet.axt.maf; done

done

########Step5: Call SVs

#!/bin/bash
#$ -N SV
#$ -q jje
#$ -m beas

export REF=/data/users/liaoy12/liaoy12/SV2020/Drosophila/genomes/ISO1

for i in `ls *.synnet`; do

cat $i | grep 'net\|^ fill\|^  gap' > synnet1.txt
cat $i | grep 'net\|^  gap\|^   fill' > synnet2.txt
cat $i | grep 'net\|^   fill\|^    gap' > synnet3.txt
cat $i | grep 'net\|^    gap\|^     fill' > synnet4.txt
cat $i | grep 'net\|top' > Net_top.txt

sed -i 's/^ fill/fill/g' Net_top.txt
sed -i 's/net/fillnet/g' synnet1.txt
sed -i 's/^ fill/fill/g' synnet1.txt
sed -i 's/^  gap/gap/g' synnet1.txt
sed -i 's/net/gapnet/g' synnet2.txt
sed -i 's/^  gap/gap/g' synnet2.txt
sed -i 's/^   fill/fill/g' synnet2.txt
sed -i 's/net/fillnet/g' synnet3.txt
sed -i 's/^   fill/fill/g' synnet3.txt
sed -i 's/^    gap/gap/g' synnet3.txt
sed -i 's/net/gapnet/g' synnet4.txt
sed -i 's/^    gap/gap/g' synnet4.txt
sed -i 's/^     fill/fill/g' synnet4.txt

perl ~/Pipeplines/Lastz_SV/SVcallerl2_NEW.pl -input synnet2.txt -output level2 -refseq $REF
perl ~/Pipeplines/Lastz_SV/SVcallerl1_NEW.pl -input synnet3.txt -output level3 -refseq $REF
perl ~/Pipeplines/Lastz_SV/SVcallerl2_NEW.pl -input synnet4.txt -output level4 -refseq $REF
perl ~/Pipeplines/Lastz_SV/SVcallerl1_NEW.pl -input synnet1.txt -output level1 -refseq $REF

perl ~/Pipeplines/Lastz_SV/filter_NEW.pl Net_top.txt level1.Complex.txt
perl ~/Pipeplines/Lastz_SV/filter_NEW.pl Net_top.txt level1.Deletion.txt
perl ~/Pipeplines/Lastz_SV/filter_NEW.pl Net_top.txt level2.CNV.txt
perl ~/Pipeplines/Lastz_SV/filter_NEW.pl Net_top.txt level2.INV.txt
perl ~/Pipeplines/Lastz_SV/filter_NEW.pl Net_top.txt level3.Complex.txt
perl ~/Pipeplines/Lastz_SV/filter_NEW.pl Net_top.txt level3.Deletion.txt
perl ~/Pipeplines/Lastz_SV/filter_NEW.pl Net_top.txt level4.CNV.txt
perl ~/Pipeplines/Lastz_SV/filter_NEW.pl Net_top.txt level4.INV.txt

cat level1.Complex.txt.synteny.out level3.Complex.txt.synteny.out > $i.complex.sv
cat level1.Deletion.txt.synteny.out level3.Deletion.txt.synteny.out > $i.deletion.sv
cat level2.CNV.txt.synteny.out level4.CNV.txt.synteny.out > $i.CNV.sv
cat level2.INV.txt.synteny.out level4.INV.txt.synteny.out > $i.INV.sv

sort -k1,1 -k2,2n $i.complex.sv > $i.complex.sort.sv
sort -k1,1 -k2,2n $i.deletion.sv > $i.deletion.sort.sv
sort -k1,1 -k2,2n $i.CNV.sv > $i.CNV.sort.sv
sort -k1,1 -k2,2n $i.INV.sv > $i.INV.sort.sv

rm $i.complex.sv $i.deletion.sv $i.CNV.sv $i.INV.sv
rm *.txt *.out
mkdir SV
mv *.sv SV;
done

########Step 6: Genotyping 
(1) genotyping deletions
#!/bin/bash
#$ -N RepeatMasker
#$ -q jje128
export Chr=3L
cat *.deletion.sort.sv > Deletions.$Chr\.txt
cat Deletions.$Chr\.txt | sort -k1,1 -k2,2n > Deletions.$Chr\.sort.txt
maf_order ../TBA/tba.$Chr\.maf ISO1 A1 A2 A3 A4 A5 A6 A7 AB8 B1 B2 B3 B4 B6 ORE Dsec Dsim Dmau Dyak Dere > tba.$Chr\.order.maf
cat tba.$Chr\.order.maf | grep "\#\|\.$Chr\|\.ut\|^$\|score" > tba.$Chr\.order.syn.maf
cat Deletions.$Chr\.sort.txt | grep -v Dere | grep -v Dyak | cut -f1-3 | uniq > $Chr\.bed
split $Chr\.bed -l 1000 sub$Chr
cat 3L.bed | awk '$3-$2<20001' > 3L.20k.bed


#!/bin/bash
#$ -N map_sub
#$ -q jje128,jje,ionode,pub64,epyc
#####$ -m beas
#$ -pe openmp 1
#$ -t 1-131

num=$SGE_TASK_ID
ID=$(head -n $num subfile.lst | tail -n 1 )
perl ../../bin/ParseMaf2fastaFinal2.pl --svraw $ID --assemblies genome.lst --singmaf ./sing -tbamaf tba.3L.order.syn.maf -outdir tmp_$ID -output $ID.
frequency.bed --refseq ISO1.3L

(2) genotyping insertions




