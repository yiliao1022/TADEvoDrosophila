#!/usr/bin/perl
use strict;
use warnings;

my $i;

for ($i=1;$i<=10000;$i++) {
system "bedtools shuffle -i Dpse.syn.bed -excl Dpse.exclude.bed -g Dpse.genome.sizes -seed $i -chrom > Dpse.syn.bed.$i.shuffle.bed";
system "bedtools intersect -wa -wb -a ../S2ToDpse.bed -b Dpse.syn.bed.$i.shuffle.bed -f 0.8 | cut -f1-3 | sort |  uniq | wc -l >> S2.permutation.10000.bed";
system "bedtools intersect -wa -wb -a ../BG3ToDpse.bed -b Dpse.syn.bed.$i.shuffle.bed -f 0.8 | cut -f1-3 | sort |  uniq | wc -l >> BG3.permutation.10000.bed";
system "bedtools intersect -wa -wb -a ../Kc167ToDpse.bed -b Dpse.syn.bed.$i.shuffle.bed -f 0.8 | cut -f1-3 | sort | uniq | wc -l >> Kc167.permutation.10000.bed";
system "rm Dpse.syn.bed.$i.shuffle.bed";
}
