#!/usr/bin/perl -w

use strict;
use warnings;

my %hash;

open In, "$ARGV[0]" or die "$!";

my $log="T_T_1_200000000000";

while (<In>) {
chomp;
my @temp = split (/\t/,$_);
my @unit1 = split (/\./,$temp[0]);
my $indel = join ("_",($unit1[0],$unit1[1],$temp[1],$temp[2],$temp[7],$temp[10]));
my @unit2 = split (/\_/,$log);
my @unit3 = split (/\./,$temp[4]);

if (($temp[1]>$unit2[2] and $temp[1]<$unit2[3]) and (($temp[2]-$unit2[2])/($unit2[3]-$unit2[2]))>0.5) {
my $species = join ("_",($unit3[0],$unit3[1],$temp[5],$temp[6]));
push @{$hash{$log}},$species;
} else {
$log = $indel;
my $species = join ("_",($unit3[0],$unit3[1],$temp[5],$temp[6]));
push @{$hash{$log}},$species;
}
}

foreach my $ind (sort keys %hash) {
  my @tmp = split (/\_/,$ind);
  print "$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[3]\t$tmp[4]\t";
  foreach my $svind (@{$hash{$ind}}) {
   print "$svind ";
  } 
  print "\t";
  print "$tmp[5]\n";
}
