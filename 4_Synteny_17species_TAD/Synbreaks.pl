#!/usr/bin/perl
use strict;
use warnings;

$/="\n";

open SIZE, "$ARGV[0]" or die "$!";
my %hash;
while (<SIZE>){
my @temp = split (/\t/,$_);
$hash{$temp[0]} =$temp[1];
}

$/="net";
open In, "$ARGV[1]" or die "$!";
open Out, ">$ARGV[1].valid.out" or die "$!";

while (<In>) {

my @temp = split (/\n/,$_);
my $head = shift @temp;
my @unit = split (/\s/,$head);
my $chr = $unit[1];
foreach my $line (@temp) {


next if ($line =~/net/);
my @tmp = split (/\s/,$line);


#############

if ($line=~/syn|nonSyn|inv/ and $tmp[6]>10000) {
my $start = $tmp[1]-5000;
my $end = $tmp[1]+5000;
my $break2_start = $tmp[1]+$tmp[2]-5000;
my $break2_end = $tmp[1]+$tmp[2]+5000;
print "$chr\t$start\t$end\n";
print "$chr\t$break2_start\t$break2_end\n";
print Out "$chr\t$line\n";
}

if ($line=~/top/ and $tmp[5]>5000 and $tmp[6]>10000 and $tmp[6]<0.95*$hash{$tmp[3]}) {
my $start = $tmp[1]-5000;
my $end = $tmp[1]+5000;
my $break2_start = $tmp[1]+$tmp[2]-5000;
my $break2_end = $tmp[1]+$tmp[2]+5000;
print "$chr\t$start\t$end\n";
print "$chr\t$break2_start\t$break2_end\n";
print Out "$chr\t$line\n";
} elsif ($line=~/top/ and $tmp[5]<5000 and $tmp[6]>10000 and $tmp[6]<0.95*$hash{$tmp[3]}) {
my $break2_start = $tmp[1]+$tmp[2]-5000;
my $break2_end = $tmp[1]+$tmp[2]+5000;
print "$chr\t$break2_start\t$break2_end\n";
print Out "$chr\t$line\n";
} elsif ($line=~/top/ and $tmp[5]>5000 and $tmp[6]>10000 and $tmp[6]>0.95*$hash{$tmp[3]}) {
my $start = $tmp[1]-5000;
my $end = $tmp[1]+5000;
print "$chr\t$start\t$end\n";
print Out "$chr\t$line\n";
}



#####
=pod
if ($tmp[6]>0.95*$hash{$tmp[3]}) {

} elsif ($tmp[5]<$hash{$tmp[3]}/10 and $tmp[6]<0.95*$hash{$tmp[3]}) {
my $break2_start = $tmp[1]+$tmp[2]-5000;
my $break2_end = $tmp[1]+$tmp[2]+5000;
print "$chr\t$break2_start\t$break2_end\n";
} else {
my $start = $tmp[1]-5000;
my $end = $tmp[1]+5000;
my $break2_start = $tmp[1]+$tmp[2]-5000;
my $break2_end = $tmp[1]+$tmp[2]+5000;
print "$chr\t$start\t$end\n";
print "$chr\t$break2_start\t$break2_end\n";
 } 
=cut
############

}

}
