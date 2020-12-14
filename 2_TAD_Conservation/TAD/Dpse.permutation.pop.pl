#!/usr/bin/perl
use strict;
use warnings;

my $i;

for ($i=1;$i<=10000;$i++) {
system "bedtools shuffle -i Dmel.syn.bed -excl Dmel.exclude.bed -g Dmel.genome.sizes -seed $i -chrom > Dmel.syn.bed.$i.shuffle.bed";
system "bedtools intersect -wa -wb -a ../Dpse2Dmel.Dpse.domains.bed -b Dmel.syn.bed.$i.shuffle.bed -f 0.8|cut -f1-3|sort|uniq| wc -l >> Dpse.permutation.10000.bed";
system "rm Dmel.syn.bed.$i.shuffle.bed";
}
