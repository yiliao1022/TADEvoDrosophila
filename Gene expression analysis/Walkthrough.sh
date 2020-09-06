### Comparsion of gene expression profile between genes that inside and outside the TADs
bedtools intersect -wa -a Dmel.Dpse.ortho.geneExp.dat -b BG3.domains.sort.bed S2.domains.sort.bed Kc167.domains.sort.bed -f 1 | sort -k1,1 -k2,2n | uniq > inside.dat
cat inside.dat | wc -l
6549
bedtools intersect -wa -a Dmel.Dpse.ortho.geneExp.dat -b BG3.domains.sort.bed S2.domains.sort.bed Kc167.domains.sort.bed -f 1 -v | sort -k1,1 -k2,2n | uniq > outside.dat
cat outside.dat | wc -l
4372
awk '{print "inside""\t"$0}' inside.dat > inside.dat1
awk '{print "outside""\t"$0}' outside.dat > outside.dat1
cat head  inside.dat1 outside.dat1 > inside.outside.dat
perl format.pl inside.outside.dat

### Comparsion of gene expression profile between genes that inside TADs that only specific to single cell line and TADs that shared at least in two cell lines
bedtools merge -i S2.domains.sort.bed > S2.domains.sort.merge.bed
bedtools merge -i Kc167.domains.sort.bed > Kc167.domains.sort.merge.bed
bedtools merge -i BG3.domains.sort.bed > BG3.domains.sort.merge.bed
bedtools intersect -wa -a Dmel.Dpse.ortho.geneExp.dat -b Kc167.domains.sort.merge.bed BG3.domains.sort.merge.bed S2.domains.sort.merge.bed -f 1 | sort -k1,1 -k2,2n | uniq -c | awk '{if ($1==1){print $0}}' > inside.specific.dat
cat inside.specific.dat | wc -l
2274
bedtools intersect -wa -a Dmel.Dpse.ortho.geneExp.dat -b Kc167.domains.sort.merge.bed BG3.domains.sort.merge.bed S2.domains.sort.merge.bed -f 1 | sort -k1,1 -k2,2n | uniq -c | awk '{if ($1==2 || $1==3){print $0}}' > inside.shared.dat
cat inside.shared.dat | wc -l
4275
awk '$1 = "shared"' inside.shared.dat | sed 's/\s/\t/g' > inside.shared.dat1
awk '$1 = "specific"' inside.specific.dat | sed 's/\s/\t/g' > inside.specific.dat1
cat head inside.shared.dat1 inside.specific.dat1 > inside.shared.specific.dat 
perl format.pl inside.shared.specific.dat

### Comparsion of gene expression profile between genes that in conserved or nonconserved TADs between Dmel and Dpse
export BED=S2.domains.sort.bed
sh work.2dpse.coordinate.sh
cat S2.domains.sort.bed.2DpseCordinate.bed.bed | awk '{if ($6-$5>0.67*($3-$2) && $6-$5<1.5*($3-$2)) {print $0}}' > S2.2Dpse.overlift.bed
export BED=BG3.domains.sort.bed
sh work.2dpse.coordinate.sh
cat BG3.domains.sort.bed.2DpseCordinate.bed.bed | awk '{if ($6-$5>0.67*($3-$2) && $6-$5<1.5*($3-$2)) {print $0}}' > BG3.2Dpse.overlift.bed
export BED=Kc167.domains.sort.bed
sh work.2dpse.coordinate.sh
cat Kc167.domains.sort.bed.2DpseCordinate.bed.bed | awk '{if ($6-$5>0.67*($3-$2) && $6-$5<1.5*($3-$2)) {print $0}}' > Kc167.2Dpse.overlift.bed
bedtools intersect -wb -a dpse_5000_blocks.bedpe.bed.bed -b Kc167.2Dpse.overlift.bed BG3.2Dpse.overlift.bed S2.2Dpse.overlift.bed -f 0.8 -F 0.8 | cut -f21-23 | sort -k1,1 -k2,2n | uniq  > Dmel.3cells.conservedwithDpse.tad.domains.bed
bedtools intersect -wa -a inside.dat -b Dmel.3cells.conservedwithDpse.tad.domains.bed -f 1 | sort | uniq > inside.conserved.dat
cat inside.conserved.dat | wc -l
1868
bedtools intersect -wa -a inside.dat -b Dmel.3cells.conservedwithDpse.tad.domains.bed -v -f 1 | sort | uniq > inside.nonconserved.dat
cat inside.nonconserved.dat | wc -l
4681
awk '{print "conserved""\t"$0}' inside.conserved.dat > inside.conserved.dat1
awk '{print "nonconserved""\t"$0}' inside.nonconserved.dat > inside.nonconserved.dat1
cat head inside.conserved.dat1 inside.nonconserved.dat1 > inside.conserved.nonconserved.dat
perl format.pl inside.conserved.nonconserved.dat

### Comparsion of gene expression profile between genes that closely linked (within 10kb) to conserved TAD boudnaries or nonconserved TAD boundaries
for i in Kc167 BG3 S2; do cat $i.domains.sort.bed | awk '{print $1"\t"$2-5000"\t"$2+5000"\n"$1"\t"$2-5000"\t"$2+5000}'| sort -k1,1 -k2,2n | uniq > $i.domains.sort.boundaries.bed;done
cat dpse_5000_blocks.bedpe.bed.bed | awk '{print $1"\t"$2-5000"\t"$2+5000"\n"$1"\t"$2-5000"\t"$2+5000}'| sort -k1,1 -k2,2n | uniq > dpse.domains.sort.boundaries.bed
for i in Kc167 BG3 S2; do export BED=$i.domains.sort.boundaries.bed; sh work.2dpse.coordinate.sh; cat $i.domains.sort.boundaries.bed.2DpseCordinate.bed.bed | awk '{if ($6-$5>0.5*($3-$2) && $6-$5<2*($3-$2)) {print $0}}' > $i.boundaries.2Dpse.overlift.bed;done
cat Kc167.boundaries.2Dpse.overlift.bed BG3.boundaries.2Dpse.overlift.bed S2.boundaries.2Dpse.overlift.bed | cut -f4-6| sort -k1,1 -k2,2n | uniq > 3cells.boundaries.bed
bedtools intersect -wa -wb -a dpse.domains.sort.boundaries.bed -b Kc167.boundaries.2Dpse.overlift.bed BG3.boundaries.2Dpse.overlift.bed S2.boundaries.2Dpse.overlift.bed | cut -f8-10 | sort -k1,1 -k2,2n | uniq > conserved.boundaries.bed
cat conserved.boundaries.bed | wc -l
296
bedtools intersect -wa -a 3cells.boundaries.bed -b conserved.boundaries.bed -v > nonconserved.boundaries.bed
cat nonconserved.boundaries.bed | wc -l
608
bedtools intersect -wa -a Dmel.Dpse.ortho.geneExp.dat -b nonconserved.boundaries.bed | sort -k1,1 -k2,2n | uniq > nonconserved.boundaries.dat
cat nonconserved.boundaries.dat | wc -l
1123
bedtools intersect -wa -a Dmel.Dpse.ortho.geneExp.dat -b conserved.boundaries.bed | sort -k1,1 -k2,2n | uniq > conserved.boundaries.dat
cat conserved.boundaries.dat | wc -l
611
awk '{print "conserved""\t"$0}' conserved.boundaries.dat > conserved.boundaries.dat1
awk '{print "nonconserved""\t"$0}' nonconserved.boundaries.dat > nonconserved.boundaries.dat1
cat head conserved.boundaries.dat1 nonconserved.boundaries.dat1 > conserved.nonconserved.boundaries.dat
perl format.pl conserved.nonconserved.boundaries.dat

### Comparsion of gene expression profile between genes that closely linked (within 10kb) to shared TAD boudnaries or specific TAD boundaries
for i in Kc167 BG3 S2;do bedtools merge -i $i.domains.sort.boundaries.bed > $i.domains.sort.boundaries.merge.bed;done
bedtools intersect -wa -a Dmel.Dpse.ortho.geneExp.dat -b Kc167.domains.sort.boundaries.merge.bed BG3.domains.sort.boundaries.merge.bed S2.domains.sort.boundaries.merge.bed | sort -k1,1 -k2,2n | uniq -c | awk '{if($1==1){print $0}}' > boundaries.specific.dat
cat boundaries.specific.dat | wc -l
1240
bedtools intersect -wa -a Dmel.Dpse.ortho.geneExp.dat -b Kc167.domains.sort.boundaries.merge.bed BG3.domains.sort.boundaries.merge.bed S2.domains.sort.boundaries.merge.bed | sort -k1,1 -k2,2n | uniq -c | awk '{if($1>1){print $0}}' > boundaries.shared.dat
cat boundaries.shared.dat | wc -l
1284
awk '$1 = "shared"' boundaries.shared.dat | sed 's/\s/\t/g' > boundaries.shared.dat1
awk '$1 = "specific"' boundaries.specific.dat | sed 's/\s/\t/g' > boundaries.specific.dat1
cat head boundaries.shared.dat1 boundaries.specific.dat1 > boundaries.shared.specific.dat
perl format.pl boundaries.shared.specific.dat
