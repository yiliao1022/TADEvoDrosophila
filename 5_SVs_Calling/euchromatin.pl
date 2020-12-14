#!/usr/bin/perl

use strict;
use warnings;


my %euchromatin = (
"ISO1.2L" => "1_22200000",
"ISO1.2R" => "5000000_25479258",
"ISO1.3L" => "1_23400000",
"ISO1.3R" => "4000000_31815305",
"ISO1.X" => "1_21900000",
);


open In, "$ARGV[0]" or die "$!";
open Out, ">$ARGV[0].euchromatin.bed" or die "$!";

while (<In>) {
my @temp = split (/\t/,$_);
my @unit = split (/_/,$euchromatin{$temp[0]});
if ($temp[1] < $unit[0] or $temp[2]>$unit[1]) {
} else {
print  Out "$_";
 }  
}
