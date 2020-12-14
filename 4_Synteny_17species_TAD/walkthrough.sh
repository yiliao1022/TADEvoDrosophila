####Step1 : genome alignment

#!/bin/bash
#$ -N map_sub
#$ -q jje,jje128
#$ -pe openmp 8
#$ -t 1
num=$SGE_TASK_ID#!/bin/bash
#$ -N ChainNet
#$ -q jje128
#$ -m beas

j=0
for i in `ls ./*.fa`;
do 
   sample[j]=$i
   j=`expr $j+1`
done
 
/data/users/liaoy12/Softwares/parallelLastz.pl --qfile /data/users/liaoy12/liaoy12/TAD/Phylogenetics/ref/dmel.chr.fasta --tfile ${sample[num-1]} --
cfile conf --speedup 8 --length 100 --sample ${sample[num-1]}Sample

####Step2 : Chain/Net/Synteny

module load jje/kent/2014.02.19
export REF=/data/users/liaoy12/liaoy12/TAD/UsingNaoassemblies/ref/dmel.fa
export Sam=/data/users/liaoy12/liaoy12/TAD/UsingNaoassemblies/ref/query.fa
faSize -detailed $REF > $REF.sizes
faSize -detailed $Sam > $Sam.sizes
faToTwoBit $REF $REF.2bit
faToTwoBit $Sam $Sam.2bit

for i in ./*.lz; do axtChain -linearGap=/share/jje/liaoy12/Date/paras/medium $i $REF.2bit $Sam.2bit $i.chain; done

chainMergeSort *chain > all.chain

chainPreNet all.chain $REF.sizes $Sam.sizes all.chain.filter

chainNet all.chain.filter $REF.sizes $Sam.sizes all.chain.filter.tnet all.chain.filter.qnet

netSyntenic all.chain.filter.tnet all.chain.filter.tnet.synnet

netSyntenic all.chain.filter.qnet all.chain.filter.qnet.synnet

netToAxt all.chain.filter.tnet.synnet all.chain.filter $REF.2bit $Sam.2bit all.chain.filter.tnet.synnet.axt

axtToMaf all.chain.filter.tnet.synnet.axt $REF.sizes $Sam.sizes -tPrefix=Dmel. -qPrefix=Dmau. all.chain.filter.tnet.synnet.axt.maf

####Step 3 process .syn file

for i in `ls *.synnet`; do cat $i | grep -v \# | grep 'net\|top\|yn\|inv' | awk '$3>10000' > $i.breaks.out; done
sed -i 's/^[ ]*//g' *.breaks.out
for i in Dana Dbia Dbip Dere Deug Dmau Dmiranda Dmoj Dper Dpse Dsec Dsim Dtria Dvir Dvir Dwil Dyak; do perl ../Synbreaks.pl $i.fasta.sizes $i.all.c
hain.filter.tnet.synnet.breaks.out > $i.all.chain.filter.tnet.synnet.breaks.out.bed ; done
for i in `ls *.bed`; do cat $i | sort -k1,1 -k2,2n | awk '$2>0' > $i.sort; done
for i in `ls *.sort`; do bedtools merge -i $i > $i.merge; done

#### Step 4 break2bin 

perl Synbreaks.pl ../Phylogenetics/Sixcomparisons/dyak.sizes Dyak.all.chain.filter.tnet.synnet.out > Dyak.all.chain.filter.tnet.synnet.out.b
ed

### run other genome like this

#### Step 5 permutation
#!/bin/bash
#$ -N temp
#$ -q jje128
#$ -m beas
#$ -t 1-16

f=$(ls *.all.chain.filter.tnet.synnet.breaks.out.bed.sort.merge | head -n $SGE_TASK_ID | tail -n 1)

module load bedtools

perl permutation.pl $f Dmel.fasta.sizes NC.TAD.bed 


