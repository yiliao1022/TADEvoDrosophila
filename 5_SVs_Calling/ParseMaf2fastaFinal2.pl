#!/usr/bin/perl

=head1 README
Description

Version and author

 SVcaller 2020.1.0
 YI Liao yiliao1022@gmail.com

Usage

=cut

use strict;
use warnings;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);

my $script = basename $0;
my ($svraw,$assemblies,$refseq,$singmaf,$tbamaf,$OUTPUTdir,$output,$threads,$help,$version,$debug);
my $myversion = "2020.0.1.0";
my $Usage = "
Hello world!
";

GetOptions(
    "svraw=s"  => \$svraw,
    "assemblies=s" => \$assemblies,
    'refseq=s'   => \$refseq,
    'singmaf=s'   => \$singmaf,
    'tbamaf=s' => \$tbamaf,
    'outdir=s' => \$OUTPUTdir,
    'output=s' => \$output,
    'threads=s'=> \$threads,
    'help'      => \$help,
    'version'   => \$version,
    'debug'     => \$debug  # use for debug, turn on Smart::Comments;
);

if($help or $version) {
    if($version) {
        print "$script version $myversion\n";
    }
    &usage();
}


#######################################################
###################### Main ###########################
#######################################################

### read genoms/assemblies ID list from a input file (How many genomes are you processed)
my @Genome;
open (GENOME,"$assemblies") or die "Genome/species names do not exist, $!";
while (<GENOME>) {
chomp;
push (@Genome,$_);
}
close GENOME;
my $ref=$Genome[0];
my $ref_g = \@Genome;
### Count the numer of lines in the raw sv file.
=pod
my $count=0;
open(FILE, "< $svraw") or die "can't open $file: $!";
$count++ while <FILE>;
=cut

$OUTPUTdir ||= ".";
$OUTPUTdir =~ s/\/$//;
mkdir($OUTPUTdir) unless(-d $OUTPUTdir);


open IN, "$svraw" or die "$!";
open OUTPUT, ">$OUTPUTdir/$output" or die "$!";


my $first=`head -1 $svraw`;
my $last=`tail -1 $svraw`;
my @beg0 = split (/\t/,$first);
my @end0 = split (/\t/,$last);
my $beg1 = $beg0[1]-2000;
if ($beg1<0) {
$beg1=0;
}
my $end1 = $end0[2]+2000;

`mafFind $tbamaf $beg1 $end1 > $svraw.sub.maf`;
`mv $svraw.sub.maf $OUTPUTdir`;

foreach my $g (@Genome) {
  if ($g eq $ref) {
    next;
  } else {
    `mafFind $singmaf/$ref.$g.sing.maf $beg1 $end1 > $svraw.$ref.$g.sing.maf`;
    `mv $svraw.$ref.$g.sing.maf $OUTPUTdir`;
  }

}


while (<IN>) {
chomp;
my @temp = split (/\t/,$_);
my $len = $temp[2]-$temp[1];
print OUTPUT "$_\t";

if ($temp[2]-$temp[1]<11) {
print OUTPUT "0 ";
foreach my $ind_genome (@Genome) {
next if ($ind_genome eq $Genome[0]);
my $extend = 10*($temp[2]-$temp[1]);
my $beg = $temp[1]-$extend;
my $end = $temp[2]+$extend;
system "maf2fasta $refseq $OUTPUTdir/$svraw.$ref.$ind_genome.sing.maf $beg $end > $OUTPUTdir/TBA.$beg\_$end.fasta";

if (-z "$OUTPUTdir/TBA.$beg\_$end.fasta") {
system "rm $OUTPUTdir/TBA.$beg\_$end.fasta";
print OUTPUT "2 ";
next;
}

my @genome_lst = ($Genome[0],"$ind_genome");
my $ref_lst =\@genome_lst;
my $ref = &ParseMaf2fasta("$OUTPUTdir/TBA.$beg\_$end.fasta",$extend,$ref_lst,$len);
if (exists $$ref{$ind_genome}) {
print OUTPUT "$$ref{$ind_genome} "
}
else {
print OUTPUT "2 "
};
system "rm $OUTPUTdir/TBA.$beg\_$end.fasta"
}
print OUTPUT "\n";
} elsif ($temp[2]-$temp[1]>10 && $temp[2]-$temp[1]<101) {
my $extend = 200;
my $beg = $temp[1]-$extend;
my $end = $temp[2]+$extend;
system "maf2fasta $refseq $OUTPUTdir/$svraw.sub.maf $beg $end > $OUTPUTdir/TBA.$beg\_$end.fasta";
if (-z "$OUTPUTdir/TBA.$beg\_$end.fasta") {
system "rm $OUTPUTdir/TBA.$beg\_$end.fasta";
print OUTPUT "\n";
next;
}

my $ref = &ParseMaf2fasta("$OUTPUTdir/TBA.$beg\_$end.fasta",$extend,$ref_g,$len);
  
  
  foreach my $key (@Genome) {
     print OUTPUT "$$ref{$key} ";
    }
     print OUTPUT "\n";

system "rm $OUTPUTdir/TBA.$beg\_$end.fasta";
} else {
my $extend = 1000;
my $beg = $temp[1]-$extend;
my $end = $temp[2]+$extend;
system "maf2fasta $refseq $OUTPUTdir/$svraw.sub.maf $beg $end > $OUTPUTdir/TBA.$beg\_$end.fasta";

if (-z "$OUTPUTdir/TBA.$beg\_$end.fasta") {
system "rm $OUTPUTdir/TBA.$beg\_$end.fasta";
print OUTPUT "\n";
next;
}

my $ref = &ParseMaf2fasta("$OUTPUTdir/TBA.$beg\_$end.fasta",$extend,$ref_g,$len);
 
  foreach my $key (@Genome) {
 
     print OUTPUT "$$ref{$key} ";
    }
     print OUTPUT "\n";
system "rm $OUTPUTdir/TBA.$beg\_$end.fasta";
}

}



`rm $OUTPUTdir/*.maf`;

#################
##### Module ####
#################


sub ParseMaf2fasta {
my ($file,$extend,$genome,$len) = @_;
my @data;
$/="\n";

my %hash;
my %hash_identity;
my %hash_deletion_overlap;

open(DATA, "$file") or die "Couldn't open file sub maf2fasta file, $!";
while (<DATA>) {
chomp;
push (@data, $_);
}
close DATA;

my @seq_num = split (/\s/,$data[0]);
my @ref_name = split (/:/,$data[1]);
my $ref = $ref_name[0];
my @ref_seq = split(//,$data[$seq_num[0]+1]);
$hash{$ref}=\@ref_seq;

my @coordinate_proxy;
my $len_n=0;
my $t;
for ($t=0;$t<$seq_num[1];$t++) {
 if ($hash{$ref}->[$t] =~/[ATGCatgc]/) {
  $len_n++;
  my $s;
  for ($s=$extend+1;$s<$extend+$len+1;$s++) {
  if ($len_n == $s) {
  push (@coordinate_proxy,$t);
   }
  }
 }
}

my $i;
for ($i=2;$i<$seq_num[0]+1;$i++) {
my @query_seq = split(//,$data[$seq_num[0]+$i]);
$hash{$data[$i]} = \@query_seq;
}

foreach my $ind (@{$genome}) {
 if (exists $hash{$ind}) {
###
my $j;
my $n;
my $m;
my $start = $coordinate_proxy[0];
my $end = $coordinate_proxy[$#coordinate_proxy];

for ($j=0;$j<$start;$j++) {
     if ($hash{$ref}->[$j] =~/[ATGCatgc]/) {
         $n++;
         $hash{$ref}->[$j] = uc ($hash{$ref}->[$j]);
       if ($hash{$ind}->[$j] =~/[ATGCatgc]/) {
           $hash{$ind}->[$j] = uc ($hash{$ind}->[$j]);
              if ($hash{$ref}->[$j] eq $hash{$ind}->[$j]) {
                 $m++;
              }
        }
     }
   }

for ($j=$end+1;$j<$seq_num[1];$j++) {
     if ($hash{$ref}->[$j] =~/[ATGCatgc]/) {
         $n++;
         $hash{$ref}->[$j] = uc ($hash{$ref}->[$j]);
       if ($hash{$ind}->[$j] =~/[ATGCatgc]/) {
           $hash{$ind}->[$j] = uc ($hash{$ind}->[$j]);
              if ($hash{$ref}->[$j] eq $hash{$ind}->[$j]) {
                 $m++;
              }
        }
     }
   }

$hash_identity{$ind} = $m/$n;
###
} else {
    $hash_identity{$ind} = 0;
 }
}

foreach my $ind1 (@{$genome}) {
   my $n1=0;
   my $m1=0;
      foreach my $coordin (@coordinate_proxy) {
         $n1++;
         if (exists $hash{$ind1} and ${$hash{$ind1}}[$coordin]=~/[ATGCatgc]/) {
         $m1++;
         }
       }
$hash_deletion_overlap{$ind1} = $m1/$n1;
}

my %hash_deletion_value;
foreach my $ind2 (@{$genome}) {
   if ($hash_identity{$ind2} < 0.5) {
       $hash_deletion_value{$ind2}=2; ### missing data
    } elsif ($hash_identity{$ind2}>=0.5 && $hash_deletion_overlap{$ind2} >= 0.5) {
       $hash_deletion_value{$ind2}=0; ### similar to reference
    } elsif ($hash_identity{$ind2}>=0.5 && $hash_deletion_overlap{$ind2} < 0.5) {
       $hash_deletion_value{$ind2}=1; ### support a deletion
    }
}
my $reference = \%hash_deletion_value;
return $reference ;
}



sub usage {
    print $Usage;
    exit;
}
