#!/usr/bin/perl
use strict;
use warnings;

my %hash;
open In, "$ARGV[0]" or die "$!";
while (<In>) {
chomp;
my @temp = split(/\t/,$_);
my $coor = join ("_",($temp[1],$temp[2]));
push (@{$hash{$temp[0]}},$coor);
}

my %hash1;
my $i;

foreach my $key (%hash) {
   for ($i=0;$i<=$#{$hash{$key}};$i++)  {
    my @unit = split (/_/,${$hash{$key}}[$i]);
    my $center = int (($unit[0]+$unit[1])/2);
    push (@{$hash1{$key}},$center);
   }
}


open In1, "$ARGV[1]" or die "$!";
my @peaks;
while (<In1>) {
chomp;
my @unit = split (/\t/,$_);
my $ele = join ("_",($unit[0],$unit[4],$unit[7]));
push (@peaks,$ele);
}


my %hash_bin;
my $j;

my @num;
my $m;
for ($m=0;$m<81;$m++) {
  $num[$m]=0;
}

foreach my $chr ( keys %hash1) {
foreach my $cen (@{$hash1{$chr}}) {
for ($j=-40;$j<41;$j++) {
my $start = $cen+$j*1000-500;
my $end = $cen+$j*1000+500;
foreach my $ind (@peaks) {
  my @peak_ind = split (/_/,$ind);
    if ($peak_ind[0] eq $chr) {
      if ($start<=$peak_ind[1] and $peak_ind[1]<=$end) {
       my $t=$j+40;   
       $num[$t]++;
      }
    }
  }
}

}
  
}



foreach my $bing (@num) {
print "$bing\t";
}
print "\n"; 
