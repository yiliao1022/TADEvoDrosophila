#!/usr/local/bin/perl 

use strict;
use warnings;


open OUT, ">$ARGV[1].simulate.txt" or die "$!";

my $i;
for ($i=($ARGV[1]-1)*100+1;$i<=($ARGV[1]-1)*100+100;$i++) {
`bedtools shuffle -i $ARGV[0] -g Dpse.genome.sizes -excl Dpse.exclude.bed -chrom -seed $i > $ARGV[0].shuffle.$i.bed`;
`computeMatrix scale-regions -S H3K4.NEW.bw H3K27.NEW.bw ATAC.bw -R $ARGV[0].shuffle.$i.bed --beforeRegionStartLength 40000 --afterRegionStartLength 40000 --regionBodyLength 5000 --binSize 1000 --skipZeros -o $ARGV[0].shuffle.$i.bed_40kb.txt.gz`;
`gunzip $ARGV[0].shuffle.$i.bed_40kb.txt.gz`;
my ($up1,$b1,$down1,$up2,$b2,$down2,$up3,$b3,$down3) = &Cal_ratio("$ARGV[0].shuffle.$i.bed_40kb.txt");
print OUT "$i\t$up1\t$b1\t$down1\t$up2\t$b2\t$down2\t$up3\t$b3\t$down3\n";
`rm $ARGV[0].shuffle.$i.bed_40kb.txt $ARGV[0].shuffle.$i.bed`;
}


#my ($up1,$b1,$down1,$up2,$b2,$down2,$up3,$b3,$down3) = &Cal_ratio("Dpse_hic_matrix.40K_binsize.1kb");
#print "Num: $up1\n$b1\n$down1$up2\t$b2\t$down2\t$up3\t$b3\t$down3\n";

sub Cal_ratio {
my $file = shift;
open In, "$file" or die "$!";
my $up_1=0;
my $mid_1=0;
my $down_1=0;
my $up_2=0;
my $mid_2=0;
my $down_2=0;
my $up_3=0;
my $mid_3=0;
my $down_3=0;

my $upn1=0;
my $midn1=0;
my $downn1=0;
my $upn2=0;
my $midn2=0;
my $downn2=0;
my $upn3=0;
my $midn3=0;
my $downn3=0;

while (<In>) {
next if ($_=~/\@/);
chomp;
my @tmp = split (/\s+/,$_);
my ($m1,$m2,$m3,$m4,$m5,$m6,$m7,$m8,$m9);

for ($m1=6;$m1<=10;$m1++) {
  if ($tmp[$m1]!~/nan/) {
  $upn1++;
  $up_1 = $up_1 + $tmp[$m1];
  }
}

for ($m2=48;$m2<=48;$m2++) {
  if ($tmp[$m2]!~/nan/) {
  $midn1++;
  $mid_1 = $mid_1 + $tmp[$m2];
  }
}

for ($m3=86;$m3<=90;$m3++) {
  if ($tmp[$m3]!~/nan/) {
  $downn1++;
  $down_1 = $down_1 + $tmp[$m3];
  }
}

for ($m4=91;$m4<=95;$m4++) {
  if ($tmp[$m4]!~/nan/) {
  $upn2++;
  $up_2 = $up_2 + $tmp[$m4];
  }
}

for ($m5=133;$m5<=133;$m5++) {
  if ($tmp[$m5]!~/nan/) {
  $midn2++;
  $mid_2 = $mid_2 + $tmp[$m5];
  }
}

for ($m6=171;$m6<=175;$m6++) {
  if ($tmp[$m6]!~/nan/) {
  $downn2++;
  $down_2 = $down_2 + $tmp[$m6];
  }
}


for ($m7=176;$m7<=180;$m7++) {
  if ($tmp[$m7]!~/nan/) {
  $upn3++;
  $up_3 = $up_3 + $tmp[$m7];
  }
}

for ($m8=218;$m8<=218;$m8++) {
  if ($tmp[$m8]!~/nan/) {
  $midn3++;
  $mid_3 = $mid_3 + $tmp[$m8];
  }
}

for ($m9=256;$m9<=260;$m9++) {
  if ($tmp[$m9]!~/nan/) {
  $downn3++;
  $down_3 = $down_3 + $tmp[$m9];
  }
}

}

my $up1_avg = $up_1/$upn1;
my $mid1_avg = $mid_1/$midn1;
my $down1_avg = $down_1/$downn1;

my $up2_avg = $up_2/$upn2;
my $mid2_avg = $mid_2/$midn2;
my $down2_avg = $down_2/$downn2;

my $up3_avg = $up_3/$upn3;
my $mid3_avg = $mid_3/$midn3;
my $down3_avg = $down_3/$downn3;

return ($up1_avg, $mid1_avg, $down1_avg, $up2_avg, $mid2_avg, $down2_avg, $up3_avg, $mid3_avg, $down3_avg);

}
