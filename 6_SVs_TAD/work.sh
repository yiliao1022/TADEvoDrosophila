cat pop.nonTE.ins.bed | cut -f1-2 | uniq -c |  awk '{print $1}' > pop.nonTE.ins.bed.fre
awk -F "\t" '{ sum=gsub(/1/, "1", $4)} {print sum}' pop.del.bed > pop.del.bed.fre
 awk '$3-$2<11' pop.del.bed | awk -F "\t" '{ sum=gsub(/1/, "1", $4)} {print sum}' | sort | uniq -c | less -S
awk '$3-$2>10 && $3-$2<2001' pop.del.bed | awk -F "\t" '{ sum=gsub(/1/, "1", $4)} {print sum}' | sort | uniq -c | less -S 
cat pop.TE.ins.bed | cut -f1-2 | uniq -c | awk '{print $1}' | sort | uniq -c | less -S
cat pop.TE.ins.bed | cut -f1-2,7 | uniq -c | awk '{print $1}' | sort -k1,1n | uniq -c | awk '{print $2"\t"$1}' > pop.TE.ins.bed.fre
awk 'FNR==NR{s+=$2;next;} {printf "%s\t%s\t%s%%\n",$1,$2,100*$2/s}' pop.TE.ins.bed.fre pop.TE.ins.bed.fre
sort -k1,1 -k2,2n pop.cnv.bed | awk '$3-$2<20001' | cut -f1-3 | uniq -c | awk '{print $1}' | sort | uniq -c > pop.cnv.bed.fre
sort -k1,1 -k2,2n pop.cnv.bed | awk '$3-$2<20001' | cut -f1-3 | uniq -c | awk '{print $1}' | sort | uniq -c | awk '{print $2"\t"$1}' > pop.cnv.bed.fre
awk 'FNR==NR{s+=$2;next;} {printf "%s\t%s\t%s%%\n",$1,$2,100*$2/s}' pop.cnv.bed.fre pop.cnv.bed.fre
awk '$3-$2<11' pop.del.bed | awk -F "\t" '{ sum=gsub(/1/, "1", $4)} {print sum}' | sort | uniq -c | awk '{print $2"\t"$1}' > pop.del.bed.fre
awk 'FNR==NR{s+=$2;next;} {printf "%s\t%s\t%s%%\n",$1,$2,100*$2/s}' pop.del.bed.fre pop.del.bed.fre
awk '$3-$2>10 && $3-$2<2001' pop.del.bed | awk -F "\t" '{ sum=gsub(/1/, "1", $4)} {print sum}' | sort | uniq -c | awk '{print $2"\t"$1}' > pop.del.bed11_2k.fre
awk 'FNR==NR{s+=$2;next;} {printf "%s\t%s\t%s%%\n",$1,$2,100*$2/s}'  pop.del.bed11_2k.fre pop.del.bed11_2k.fre
cat pop.nonTE.ins.bed | sort -k1,1 -k2,2n | cut -f1-3,7 | awk '$4<20001'| uniq -c | awk '$5<11' | awk '{print $2"\t"$1}' > pop.nonTE.ins.bed1_10bp.fre
cat pop.nonTE.ins.bed | sort -k1,1 -k2,2n | cut -f1-3,7 | awk '$4<20001'| uniq -c | awk '$5>10' | awk '{print $2"\t"$1}' > pop.nonTE.ins.bed11_20K.fre
cat pop.nonTE.ins.bed | sort -k1,1 -k2,2n | cut -f1-3,7 | awk '$4<20001'| uniq -c | awk '$5<11' | awk '{print $1}' | sort | uniq -c | awk '{print $2"\t"$1}' > pop.nonTE.ins.bed1_10bp.fre
cat pop.nonTE.ins.bed | sort -k1,1 -k2,2n | cut -f1-3,7 | awk '$4<20001'| uniq -c | awk '$5>10' | awk '{print $1}' | sort | uniq -c | awk '{print $2"\t"$1}' > pop.nonTE.ins.bed11_20K.fre
awk 'FNR==NR{s+=$2;next;} {printf "%s\t%s\t%s%%\n",$1,$2,100*$2/s}' pop.nonTE.ins.bed11_20K.fre pop.nonTE.ins.bed11_20K.fre
awk 'FNR==NR{s+=$2;next;} {printf "%s\t%s\t%s%%\n",$1,$2,100*$2/s}' pop.nonTE.ins.bed1_10bp.fre pop.nonTE.ins.bed1_10bp.fre
cat /data/users/liaoy12/liaoy12/SV2020/Drosophila/step1_alignment/Lastz/genomePair/SV_insertions/pop.ISO1.cnv.bed | cut -f5-7 | awk '$3-$2>49' | awk '$3-$2<20001' | wc -l > POP.redundancy.CNV.bed
