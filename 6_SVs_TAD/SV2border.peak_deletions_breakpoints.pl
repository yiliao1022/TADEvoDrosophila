#!/usr/bin/perl

use strict;
use warnings;

my $i;
my $bin=$ARGV[2];
my $range = $ARGV[3];
my $m=$range/$bin;

for($i=-$m;$i<$m+1;$i++) {
   open In, "$ARGV[0]" or die "$!";
   open Out, ">$ARGV[0].flank.$i\_K.bed" or die "$!";
   
 while (<In>) {
   chomp;
   my @temp = split(/\t/,$_);
   my $start;
   my $end;
   if ($i<0) {
   $start = 2*$temp[1]-$temp[2]+$bin*($i+1);
   $end   = $temp[1] + $bin*($i+1);
   } elsif ($i==0) {
   $start = $temp[1];
   $end = $temp[2];
   } elsif ($i>0) {
   $start = $temp[2]+$bin*($i-1);
   $end   = 2*$temp[2]-$temp[1]+$bin*($i-1);
   }
    if ($start<0) {
         $start =0;
      } 
    if ($end <0) {
         $end =0;
     }
  print Out "$temp[0]\t$start\t$end\n";
 }

  system "bedtools intersect -a $ARGV[1] -b $ARGV[0].flank.$i\_K.bed -u | wc -l >> $ARGV[1].peak.breatpoints.bed";
  system "rm $ARGV[0].flank.$i\_K.bed";
}


print "The number is -$m\t$m\n";
`for i in {-$m..$m}; do echo \$i >> coordinate.bed; done`;
system "paste coordinate.bed $ARGV[1].peak.breatpoints.bed > $ARGV[1].peak.breatpoints.bed.bed";
system "rm $ARGV[1].peak.breatpoints.bed";
system "rm coordinate.bed";
