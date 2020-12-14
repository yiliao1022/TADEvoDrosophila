#!/usr/bin/perl
use strict;
use warnings;

my $i;

for ($i=1;$i<=10000;$i++) {
system "bedtools shuffle -i ../Kc167.boundaries.bed -excl Dmel.exclude.bed -g Dmel.genome.sizes -seed $i -chrom > Kc167.boundaries.shuffle.$i.bed";
system "bedtools shuffle -i ../BG3.boundaries.bed -excl Dmel.exclude.bed -g Dmel.genome.sizes -seed $i -chrom > BG3.boundaries.shuffle.$i.bed";
system "bedtools shuffle -i ../S2.boundaries.bed -excl Dmel.exclude.bed -g Dmel.genome.sizes -seed $i -chrom > S2.boundaries.shuffle.$i.bed";
&ref1("Kc167.boundaries.shuffle.$i.bed",$i);
&ref1("BG3.boundaries.shuffle.$i.bed",$i);
&ref1("S2.boundaries.shuffle.$i.bed",$i);
system "~/Pipeplines/linux.x86_64/liftOver Kc167.boundaries.shuffle.$i.bed.$i.bed Dmel.Dpse.chain.filter Kc167.shuffle.$i.ToDpse.tmp.bed Unmap$i -minMatch=0.33";
system "~/Pipeplines/linux.x86_64/liftOver BG3.boundaries.shuffle.$i.bed.$i.bed Dmel.Dpse.chain.filter BG3.shuffle.$i.ToDpse.tmp.bed Unmap$i -minMatch=0.33";
system "~/Pipeplines/linux.x86_64/liftOver S2.boundaries.shuffle.$i.bed.$i.bed Dmel.Dpse.chain.filter S2.shuffle.$i.ToDpse.tmp.bed Unmap$i -minMatch=0.33";
&ref2("Kc167.shuffle.$i.ToDpse.tmp.bed");
&ref2("BG3.shuffle.$i.ToDpse.tmp.bed");
&ref2("S2.shuffle.$i.ToDpse.tmp.bed");
system "cat Kc167.shuffle.$i.ToDpse.tmp.bed.bed | wc -l >> Kc167.liftover.bed";
system "cat BG3.shuffle.$i.ToDpse.tmp.bed.bed | wc -l >> BG3.liftover.bed";
system "cat S2.shuffle.$i.ToDpse.tmp.bed.bed | wc -l >> S2.liftover.bed";
system "bedtools intersect -wa -wb -a Kc167.shuffle.$i.ToDpse.tmp.bed.bed -b ../Dpse.boundaries.bed | cut -f1-3 | sort | uniq | wc -l >> Kc167.con.bed";
system "bedtools intersect -wa -wb -a BG3.shuffle.$i.ToDpse.tmp.bed.bed -b ../Dpse.boundaries.bed | cut -f1-3 | sort | uniq | wc -l >> BG3.con.bed";
system "bedtools intersect -wa -wb -a S2.shuffle.$i.ToDpse.tmp.bed.bed -b ../Dpse.boundaries.bed | cut -f1-3 | sort | uniq | wc -l >> S2.con.bed";
system "rm Unmap* *.shuffle.$i.bed *.shuffle.$i.bed.$i.bed *.tmp.bed *.tmp.bed.bed"; 

}

sub ref2 {
my $file = shift;
open In, "$file" or die "$!";
open Out, ">$file.bed" or die "$!";
while (<In>) {
chomp;
my @tmp = split(/\t/,$_);
if ($tmp[2]-$tmp[1]<20000) {
print Out "$_\n";
}

}


}




sub ref1 {
my ($file,$n) = @_;
open In, "$file" or die "$!";
open Out, ">$file.$n.bed" or die "$!";
while (<In>) {
chomp;
my @tmp = split (/\t/,$_);
print Out "$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[2]\n";
 }
}



