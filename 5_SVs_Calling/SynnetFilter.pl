#!/usr/bin/perl
use strict;
use warnings;

#remove non syntenic fills from *.chain.filter.tnet.synnet to keep only syntenic, conserved and reliable orthologous alignments
#Authors: Yi Liao (05/24/2020)
#usage: perl SynnetFilter.pl *.chain.filter.tnet.synnet

open In, "$ARGV[0]" or die "$!";
open Out, ">$ARGV[0].filter" or die "$!";

my $tag=0;
my $tag1=0;
my $tag2=0;
my $len_cutoff = 10000;
my $qFar_cutoff = 5000000;

while (<In>) {
chomp;
if ($_=~/^net|\#/) {
  print Out "$_\n"; 
} elsif ($_=~/^\s{1}fill/) {
my @temp = split (/\s/, $_);
my $ref = \@temp;
my $ali_idx = &array_search ($ref,"ali");
 if ($temp[$ali_idx+1]> $len_cutoff) {
 print Out "$_\n";
 $tag2=0;
 } else {
 $tag2=1;
 }
} elsif ($_=~/^\s{2}gap/ and $tag2==0) {
print Out "$_\n"; 

}elsif ($_=~/^\s{3}fill/ and $_=~/nonSyn/) {
   $tag=1;
} elsif ($_=~/^\s{3}fill/ and $_=~/syn|inv/) {
     my @temp = split (/\s/, $_);
     my $ref = \@temp;
     my $ali_idx = &array_search ($ref,"ali");
     my $qFar_idx = &array_search ($ref,"qFar");
     if ($temp[$ali_idx+1]>$len_cutoff and $temp[$qFar_idx+1]<$qFar_cutoff) {
         print Out "$_\n"; 
         $tag=0;
        } else {
         $tag=1;
        } 
} elsif ($_=~/^\s{4}gap/ and $tag==0) {
        print Out "$_\n";
} elsif ($_=~/^\s{5}fill/ and $_=~/nonSyn/) {
        $tag1=1;
} elsif ($_=~/^\s{5}fill/ and $_=~/syn|inv/) {
  my @temp = split (/\s/, $_);
  my $ref = \@temp;
  my $ali_idx = &array_search ($ref,"ali");
  my $qFar_idx = &array_search ($ref,"qFar"); 
if ($temp[$ali_idx+1]>$len_cutoff and $temp[$qFar_idx+1]<$qFar_cutoff) {
    print Out "$_\n";
    $tag1=0;
  } else {
    $tag1=1;
  }  
} elsif ($_=~/^\s{6}gap/ and $tag1=0) {
     print Out "$_\n";
} else {
  next;
}

}

#######sub Function


sub array_search {
    my ($arr, $elem) = @_;
    my $idx;
    for my $i (0..$#$arr) {
        if ($arr->[$i] eq $elem) {
            $idx = $i;
            last;
        }
    }
    return $idx;            
}
