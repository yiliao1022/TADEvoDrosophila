
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
 


