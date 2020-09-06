### Comparsion of gene expression profile between genes that inside and outside the TADs

bedtools intersect -wa -a Dmel.Dpse.ortho.geneExp.dat -b BG3.domains.sort.bed S2.domains.sort.bed Kc167.domains.sort.bed -f 1 | sort -k1,1 -k2,2n | uniq > inside.dat
cat inside.dat | wc -l
6549
bedtools intersect -wa -a Dmel.Dpse.ortho.geneExp.dat -b BG3.domains.sort.bed S2.domains.sort.bed Kc167.domains.sort.bed -f 1 -v | sort -k1,1 -k2,2n | uniq > outside.dat
cat outside.dat | wc -l
4372

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

### Comparsion of gene expression profile between genes that in conserved or noncopnserved TADs between Dmel and Dpse


### Comparsion of gene expression profile between genes that closely linked (within 10kb) to conserved TAD boudnaries or nonconserved TAD boundaries
