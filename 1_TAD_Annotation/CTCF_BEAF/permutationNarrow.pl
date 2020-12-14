#!/usr/local/bin/perl 

use strict;
use warnings;


my $i;
for ($i=($ARGV[1]-1)*100+1;$i<=($ARGV[1]-1)*100+100;$i++) {
`bedtools shuffle -i $ARGV[0] -g Dpse.genome.sizes -excl Dpse.exclude.bed -chrom -seed $i > $ARGV[0].shuffle.$i.bed`;
`perl chip_overlap40kb.pl $ARGV[0].shuffle.$i.bed BEAF.peak.list >> BEAF.simulate.txt`;
`rm $ARGV[0].shuffle.$i.bed`;
}

