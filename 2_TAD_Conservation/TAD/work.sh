all.10kb.synteny.blocks.sort.10kb.links.final.out
cat all.10kb.synteny.blocks.sort.10kb.links.final.out | cut -d " " -f4-6 | awk '{print $1"\t"$2"\t"$3}' | sort -k1,1 -k2,2n > Dpse.syn.bed
cat all.10kb.synteny.blocks.sort.10kb.links.final.out | cut -d " " -f1-3 | awk '{print $1"\t"$2"\t"$3}' | sort -k1,1 -k2,2n > Dmel.syn.bed
cp ~/liaoy12/Data/Dpseu/CHIP_seq/deepTools_plot/2020may15/permutaion/Dpse.exclude.bed ./
cp ~/liaoy12/Data/Dpseu/CHIP_seq/deepTools_plot/2020may15/permutaion/Dpse.genome.sizes ./
cat Dpse.syn.bed | awk '{if($3>$2) {print $1"\t"$2"\t"$3} else {print $1"\t"$3"\t"$2}}' > Dpse.syn.bed.bed
cat Dpse.syn.bed | grep -v chr5 > Dpse.syn.bed.bed
mv Dpse.syn.bed.bed  Dpse.syn.bed
cat Dmel.syn.bed | awk '{if($1!=4) {print $0}}' > Dmel.syn.bed.bed
bedtools intersect -wa -wb -a ../Kc167ToDpse.bed -b Dpse.syn.bed -f 0.8 | cut -f1-3 | sort | uniq | wc -l
bedtools intersect -wa -wb -a ../BG3ToDpse.bed -b Dpse.syn.bed -f 0.8 | cut -f1-3 | sort | uniq | wc -l
bedtools intersect -wa -wb -a ../S2ToDpse.bed -b Dpse.syn.bed -f 0.8 | cut -f1-3 | sort | uniq | wc -l
bedtools intersect -wa -wb -a ../Dpse2Dmel.Dpse.domains.bed -b Dmel.syn.bed -f 0.8 | cut -f1-3 | sort | uniq | wc -l
