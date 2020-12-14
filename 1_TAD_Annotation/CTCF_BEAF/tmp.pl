open In, "$ARGV[0]" or die "$!";

while (<In>) {
 chomp;
 my @tmp = split (/\t/,$_);
 foreach my $i (@tmp) {
 print "$i\n";
 }
}
