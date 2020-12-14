#!/usr/bin/perl
use strict;
use warnings;

my %hash;
open In, "$ARGV[0]" or die "$!";
while (<In>) {
chomp;
my @temp = split(/\t/,$_);
my $coordinate = join ("_",($temp[1],$temp[2]));
push (@{$hash{$temp[0]}},$coordinate);
}

open SV, "$ARGV[1]" or die "$!";
my @breaks;
while (<SV>) {
chomp;
my @unit = split (/\t/,$_);
my $ele = join ("_",($unit[0],$unit[1],$unit[2]));
push (@breaks,$ele);
}


my @counts=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
foreach my $key (%hash) {
   foreach my $coordinate (@{$hash{$key}}) {
       my @bins;
       my @tmp = split (/_/,$coordinate);
       my $len = $tmp[1]-$tmp[0];
       my $start = int ($tmp[0]-($len/2));
       my $end = int ($tmp[1]+($len/2));
       my $bin = int ($len/10);
       my $i;

       for ($i=0;$i<20;$i++) {
            $bins[$i]=0;
            my $s = $start+$i*$bin;
            my $e = $start+($i+1)*$bin;
             foreach my $ind (@breaks) {
                my @peak_ind = split (/_/,$ind);
                my $center = int (($peak_ind[1]+$peak_ind[2])/2);
                if ($peak_ind[0] eq $key) {
                if ($s<=$center and $center<=$e) {          
                            $bins[$i]++;
                         }       
                    } 
               }
          }

            #print "$key\t$coordinate\t";
            #print @bins;    
                
         my $j;
         for ($j=0;$j<20;$j++) {
             $counts[$j]=$counts[$j]+$bins[$j];
         }

    }            

  }

foreach my $num (@counts) {
  print "$num\t";
}
print "\n";



