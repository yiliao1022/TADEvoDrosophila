#!/bin/bash
#$ -N temp
#$ -q jje128
#$ -m beas

module load bedtools
export DEL=3p.del.bed
export INS=3p.NonTE.ins.bed
export TE=3p.TE.ins.bed
export CNV=3p.cnv.bed
export CNVALL=3p.cnv.bed

cat $INS | sort -k1,1 -k2,2n | cut -f1-3,7 | awk '$4<20001'| uniq > $INS.uniq.bed
cat $INS | sort -k1,1 -k2,2n | cut -f1-3,7 | awk '$4<20001'| uniq | awk '$4<11' > $INS.uniq.bed1_10bp
cat $INS | sort -k1,1 -k2,2n | cut -f1-3,7 | awk '$4<20001'| uniq | awk '$4>10' > $INS.uniq.bed11_20kb
cat $INS | sort -k1,1 -k2,2n | cut -f1-3,7 | awk '$4<20001'| uniq -c | awk '$1==1' | awk '{print $2"\t"$3"\t"$4"\t"$5}\' > $INS.uniq.bed_rare
cat $INS | sort -k1,1 -k2,2n | cut -f1-3,7 | awk '$4<20001'| uniq -c | awk '$1>1' | awk '{print $2"\t"$3"\t"$4"\t"$5}\' > $INS.uniq.bed_common
for i in $INS.uniq.bed $INS.uniq.bed1_10bp $INS.uniq.bed11_20kb $INS.uniq.bed_rare $INS.uniq.bed_common; do perl ../bin/SV2border.peak_insertions_500bpmoving.pl ../Boundaries/2NCpapes.overlap.tad.boundaries.uniq.bed.euchromatin.bed.euchromatin.bed.bed $i 1000 100000;done

for i in $INS.uniq.bed $INS.uniq.bed1_10bp $INS.uniq.bed11_20kb $INS.uniq.bed_rare $INS.uniq.bed_common; do wc -l $i | awk '{print $i"\t""breakpoints are""\t"$1}' >> Result.txt; done
for i in $INS.uniq.bed $INS.uniq.bed1_10bp $INS.uniq.bed11_20kb $INS.uniq.bed_rare $INS.uniq.bed_common; do cat $i | awk '{sum+=$4} END {print $i"\t""Coverage is""\t"sum}' >> Result.txt; done


cat $DEL | awk '$3-$2<2001' | sort -k1,1 -k2,2n | cut -f1-3 | uniq  > $DEL.uniq.bed
cat $DEL | awk '$3-$2<2001' | sort -k1,1 -k2,2n | cut -f1-3 | uniq | awk '$3-$2<11' > $DEL.uniq.bed1_10bp
cat $DEL | awk '$3-$2<2001' | sort -k1,1 -k2,2n | cut -f1-3 | uniq | awk '$3-$2>10' > $DEL.uniq.bed11_2000bp

cat $DEL | awk '{print $1"\t"$2"\t"$3"\t"$19" "$20" "$21}' | awk -F "\t" '{ if (gsub(/1/, "1", $4) ==1 ) print $1"\t"$2"\t"$3}' > $DEL.uniq.bed_rare
cat $DEL | awk '{print $1"\t"$2"\t"$3"\t"$19" "$20" "$21}' | awk -F "\t" '{ if (gsub(/1/, "1", $4) >1 ) print $1"\t"$2"\t"$3}' > $DEL.uniq.bed_common
#cat $DEL | awk '$3-$2<2001' | sort -k1,1 -k2,2n | cut -f1-3 | uniq -c | awk '$1==1' | awk '{print $2"\t"$3"\t"$4}' > $DEL.uniq.bed_rare
#cat $DEL | awk '$3-$2<2001' | sort -k1,1 -k2,2n | cut -f1-3 | uniq -c | awk '$1>1' | awk '{print $2"\t"$3"\t"$4}' > $DEL.uniq.bed_common


for i in $DEL.uniq.bed $DEL.uniq.bed1_10bp $DEL.uniq.bed11_2000bp $DEL.uniq.bed_rare $DEL.uniq.bed_common; do perl ../bin/SV2border.peak_deletions_coverage.pl ../Boundaries/2NCpapes.overlap.tad.boundaries.uniq.bed.euchromatin.bed.euchromatin.bed.bed $i 1000 100000;done
for i in $DEL.uniq.bed $DEL.uniq.bed1_10bp $DEL.uniq.bed11_2000bp $DEL.uniq.bed_rare $DEL.uniq.bed_common; do cat $i | awk '{sum+=$3-$2} END {print $i"\t""Coverage is""\t"sum}' >> Result.txt; done

cat $DEL.uniq.bed | awk '{print $1"\t"$2"\t"$2"\n"$1"\t"$3"\t"$3}' > $DEL.uniq.breakpionts.bed
cat $DEL.uniq.bed1_10bp | awk '{print $1"\t"$2"\t"$2"\n"$1"\t"$3"\t"$3}' > $DEL.uniq.breakpionts.bed1_10bp
cat $DEL.uniq.bed11_2000bp | awk '{print $1"\t"$2"\t"$2"\n"$1"\t"$3"\t"$3}' > $DEL.uniq.breakpionts.bed11_2000bp
cat $DEL.uniq.bed_rare | awk '{print $1"\t"$2"\t"$2"\n"$1"\t"$3"\t"$3}' > $DEL.uniq.breakpoints.bed_rare
cat $DEL.uniq.bed_common | awk '{print $1"\t"$2"\t"$2"\n"$1"\t"$3"\t"$3}' > $DEL.uniq.breakpoints.bed_common

for i in $DEL.uniq.breakpionts.bed $DEL.uniq.breakpionts.bed1_10bp $DEL.uniq.breakpionts.bed11_2000bp $DEL.uniq.breakpoints.bed_rare $DEL.uniq.breakpoints.bed_common; do perl ../bin/SV2border.peak_deletions_breakpoints.pl ../Boundaries/2NCpapes.overlap.tad.boundaries.uniq.bed.euchromatin.bed.euchromatin.bed.bed $i 1000 100000;done
for i in $DEL.uniq.breakpionts.bed $DEL.uniq.breakpionts.bed1_10bp $DEL.uniq.breakpionts.bed11_2000bp $DEL.uniq.breakpoints.bed_rare $DEL.uniq.breakpoints.bed_common; do wc -l $i | awk '{print $i"\t""breakpoints are""\t"$1}' >> Result.txt; done

sort -k1,1 -k2,2n $CNV | cut -f1-3 | uniq | awk '$3-$2<20001' > $CNV.uniq.bed1_20k
cat $CNV.uniq.bed1_20k | awk '{print $1"\t"$2"\t"$2"\n"$1"\t"$3"\t"$3}' > $CNV.uniq.breakpoints.bed1_20k
sort -k1,1 -k2,2n $CNVALL | cut -f1-3 | uniq | awk '$3-$2<20001' > $CNVALL.uniq.bed1_20k
cat $CNVALL.uniq.bed1_20k | awk '{print $1"\t"$2"\t"$2"\n"$1"\t"$3"\t"$3}' > $CNVALL.uniq.breakpoints.bed1_20k

for i in $CNV.uniq.bed1_20k $CNVALL.uniq.bed1_20k; do perl ../bin/SV2border.peak_deletions_coverage.pl ../Boundaries/2NCpapes.overlap.tad.boundaries.uniq.bed.euchromatin.bed.euchromatin.bed.bed $i 1000 100000;done
for i in $CNV.uniq.breakpoints.bed1_20k $CNVALL.uniq.breakpoints.bed1_20k; do perl ../bin/SV2border.peak_deletions_breakpoints.pl ../Boundaries/2NCpapes.overlap.tad.boundaries.uniq.bed.euchromatin.bed.euchromatin.bed.bed $i 1000 100000;done

for i in $CNV.uniq.bed1_20k $CNVALL.uniq.bed1_20k; do cat $i | awk '{sum+=$3-$2} END {print $i"\t""Coverage is""\t"sum}' >> Result.txt; done
for i in $CNV.uniq.breakpoints.bed1_20k $CNVALL.uniq.breakpoints.bed1_20k; do wc -l $i | awk '{print $i"\t""breakpoints are""\t"$1}' >> Result.txt; done



sort -k1,1 -k2,2n $TE | cut -f1-3,7 | uniq > TE.all.uniq.bed
sort -k1,1 -k2,2n $TE | grep LINE | cut -f1-3,7 | uniq  > TE.LINE.uniq.bed
sort -k1,1 -k2,2n $TE | grep LTR | cut -f1-3,7 | uniq > TE.LTR.uniq.bed
sort -k1,1 -k2,2n $TE | grep -v LTR | grep -v LINE | cut -f1-3,7 | uniq > TE.DNA.uniq.bed

for i in TE.all.uniq.bed TE.LINE.uniq.bed TE.LTR.uniq.bed TE.DNA.uniq.bed; do perl ../bin/SV2border.peak_insertions_500bpmoving.pl ../Boundaries/2NCpapes.overlap.tad.boundaries.uniq.bed.euchromatin.bed.euchromatin.bed.bed $i 1000 100000;done
for i in TE.all.uniq.bed TE.LINE.uniq.bed TE.LTR.uniq.bed TE.DNA.uniq.bed; do wc -l $i | awk '{print $i"\t""breakpoints are""\t"$1}' >> Result.txt; done
for i in TE.all.uniq.bed TE.LINE.uniq.bed TE.LTR.uniq.bed TE.DNA.uniq.bed; do cat $i | awk '{sum+=$4} END {print $i"\t""Coverage is""\t"sum}' >> Result.txt; done


