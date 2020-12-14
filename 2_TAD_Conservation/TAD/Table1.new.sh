module load bedtools
module load solarese/kent/1

export DPSE=Dpse.domains.bed
export KC167=Kc167.domains.bed
export BG3=BG3.domains.bed
export S2=S2.domains.bed
export RATE=0.9

cat Kc167.domains.bed | awk '{print $1"\t"$2"\t"$3"\t"$1"\t"$2"\t"$3"\t"$3}' > Kc167.domains.bed.bed;
cat BG3.domains.bed | awk '{print $1"\t"$2"\t"$3"\t"$1"\t"$2"\t"$3"\t"$3}' > BG3.domains.bed.bed;
cat S2.domains.bed | awk '{print $1"\t"$2"\t"$3"\t"$1"\t"$2"\t"$3"\t"$3}' > S2.domains.bed.bed;

for i in BG3 Kc167 S2; do liftOver $i.domains.bed.bed Dmel.Dpse.chain.filter $i\ToDpse.tmp.bed Unmap$i -minMatch=0.25;done
for i in BG3 Kc167 S2; do cat $i\ToDpse.tmp.bed | awk '{if (($7-$5)/($3-$2)>2/3 && ($7-$5)/($3-$2)<1.5) {print $0}}' > $i\ToDpse.bed;done

cat S2ToDpse.bed | awk '{print $0"\t""S2"}' | sort -k1,1 -k2,2n > S2ToDpse.bed.bed
cat Kc167ToDpse.bed | awk '{print $0"\t""Kc167"}' | sort -k1,1 -k2,2n > Kc167ToDpse.bed.bed
cat BG3ToDpse.bed | awk '{print $0"\t""BG3"}' | sort -k1,1 -k2,2n > BG3ToDpse.bed.bed

export Kc167all=`cat Kc167.domains.bed | awk '{sum+=$3-$2} END {print sum}'`
export BG3all=`cat BG3.domains.bed | awk '{sum+=$3-$2} END {print sum}'`
export S2all=`cat S2.domains.bed | awk '{sum+=$3-$2} END {print sum}'`

export Kc167alln=`cat Kc167.domains.bed | wc -l`
export BG3alln=`cat BG3.domains.bed | wc -l`
export S2alln=`cat S2.domains.bed | wc -l`

export Kc167liftover=`cat Kc167ToDpse.bed.bed | awk '{sum+=$7-$5} END {print sum}'`
export BG3liftover=`cat BG3ToDpse.bed.bed | awk '{sum+=$7-$5} END {print sum}'`
export S2liftover=`cat S2ToDpse.bed.bed | awk '{sum+=$7-$5} END {print sum}'`

export Kc167liftovern=`cat Kc167ToDpse.bed.bed | wc -l`
export BG3liftovern=`cat BG3ToDpse.bed.bed | wc -l`
export S2liftovern=`cat S2ToDpse.bed.bed | wc -l`

export Kc167shareN=`bedtools intersect -wa -wb -a Kc167ToDpse.bed.bed -b Dpse.domains.bed -f $RATE -F $RATE | cut -f1-3 | sort -k1,1 -k2,2n | uniq | wc -l`
export BG3shareN=`bedtools intersect -wa -wb -a BG3ToDpse.bed.bed -b Dpse.domains.bed -f $RATE -F $RATE | cut -f1-3 | sort -k1,1 -k2,2n | uniq | wc -l`
export S2shareN=`bedtools intersect -wa -wb -a S2ToDpse.bed.bed -b Dpse.domains.bed -f $RATE -F $RATE | cut -f1-3 | sort -k1,1 -k2,2n | uniq | wc -l`

export Kc167share=`bedtools intersect -wa -wb -a Kc167ToDpse.bed.bed -b Dpse.domains.bed -f $RATE -F $RATE | cut -f1-3,5,7 | sort -k1,1 -k2,2n | uniq | awk '{sum+=$5-$4}END{print sum}'`
export BG3share=`bedtools intersect -wa -wb -a BG3ToDpse.bed.bed -b Dpse.domains.bed -f $RATE -F $RATE | cut -f1-3,5,7 | sort -k1,1 -k2,2n | uniq | awk '{sum+=$5-$4}END{print sum}'`
export S2share=`bedtools intersect -wa -wb -a S2ToDpse.bed.bed -b Dpse.domains.bed -f $RATE -F $RATE | cut -f1-3,5,7 | sort -k1,1 -k2,2n | uniq | awk '{sum+=$5-$4}END{print sum}'`

export Dpsealln=`cat $DPSE | wc -l`
export Dpseall=`cat $DPSE | awk '{sum+=$3-$2} END {print sum}'`

cat $DPSE | awk '{print $1"\t"$2"\t"$3"\t"$1"\t"$2"\t"$3"\t"$3}' > $DPSE.bed

liftOver $DPSE.bed Dpse.Dmel.chain.filter Dpse2Dmel.tmp.$DPSE Unmap$DPSE -minMatch=0.25

cat Dpse2Dmel.tmp.$DPSE | awk '{if (($7-$5)/($3-$2)>2/3 && ($7-$5)/($3-$2)<1.5) {print $0}}' > Dpse2Dmel.$DPSE

export Dpseliftn=`cat Dpse2Dmel.$DPSE | wc -l`
export Dpselift=`cat Dpse2Dmel.$DPSE | awk '{sum+=$7-$5} END {print sum}'`

export Dpsesharen=`bedtools intersect -wa -wb -a Dpse2Dmel.$DPSE -b $KC167 $BG3 $S2 -f $RATE -F $RATE | cut -f1-3,5,7| sort -k1,1 -k2,2n  | uniq | wc -l`
export Dpseshare=`bedtools intersect -wa -wb -a Dpse2Dmel.$DPSE -b $KC167 $BG3 $S2 -f $RATE -F $RATE | cut -f1-3,5,7| sort -k1,1 -k2,2n  | uniq | awk '{sum+=$5-$4}END{print sum}'`

echo "Dpse: $Dpsealln $Dpseliftn $Dpsesharen"
echo "Dpse: $Dpseall $Dpselift $Dpseshare"
echo "Kc167: $Kc167alln $Kc167liftovern $Kc167shareN"
echo "Kc167: $Kc167all $Kc167liftover $Kc167share"
echo "BG3: $BG3alln $BG3liftovern $BG3shareN"
echo "BG3: $BG3all $BG3liftover $BG3share"
echo "S2: $S2alln $S2liftovern $S2shareN"
echo "S2: $S2all $S2liftover $S2share"


#rm Dpse2Dmel* Kc167.domains.bed.bed $DPSE.bed BG3.domains.bed.bed  *ToDpse* Unmap* S2.domains.bed.bed
