#!/usr/bin/perl

use strict;
use warnings;

my $i;

for ($i=1;$i<=10000;$i++) {
system "bedtools shuffle -i $ARGV[0] -g Dmel.genome.sizes -excl Dmel.exclude.bed -chrom -seed $i > $ARGV[0].shuffle.$i.bed";
system "bedtools intersect -a $ARGV[0].shuffle.$i.bed -b /data/users/liaoy12/liaoy12/TAD_SV/7_SV_TAD_2020Feb18/Boundaries/2NCpapes.overlap.tad.boundaries.uniq.bed.euchromatin.bed.euchromatin.bed.bed -u | wc -l >> $ARGV[0].permutation.breaks.bed";
system "bedtools intersect -a $ARGV[0].shuffle.$i.bed -b /data/users/liaoy12/liaoy12/TAD_SV/7_SV_TAD_2020Feb18/Boundaries/2NCpapes.overlap.tad.boundaries.uniq.bed.euchromatin.bed.euchromatin.bed.bed | awk '{sum+=\$4} END {print sum}' >> $ARGV[0].permutation.cov.bed";
system "rm $ARGV[0].shuffle.$i.bed";

}
