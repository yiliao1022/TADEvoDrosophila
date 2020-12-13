use strict;
use warnings;

open In, "$ARGV[0]" or die "$!";
open Out, ">$ARGV[0].out" or die "$!";

print Out "Types\tTFBgnID\tTchr\tTbeg\tTend\tQFBgnID\tQchr\tQbeg\tQend\tw1118_f_ac\tw1118_f_dg\tw1118_f_ge\tw1118_f_go\tw1118_f_hd\tw1118_f_re\tw1118_f_tx\tw1118_f_wb\tw1118_m_ac\tw1118_m_dg\tw1118_m_ge\tw1118_m_go\tw1118_m_hd\tw1118_m_re\tw1118_m_tx\tw1118_m_wb\toreR_f_ac\toreR_f_dg\toreR_f_ge\toreR_f_go\toreR_f_hd\toreR_f_re\toreR_f_tx\toreR_f_wb\toreR_m_ac\toreR_m_dg\toreR_m_ge\toreR_m_go\toreR_m_hd\toreR_m_re\toreR_m_tx\toreR_m_wb\tdpse_f_ac\tdpse_f_dg\tdpse_f_go\tdpse_f_hd\tdpse_f_re\tdpse_f_tx\tdpse_f_wb\tdpse_m_ac\tdpse_m_dg\tdpse_m_go\tdpse_m_hd\tdpse_m_re\tdpse_m_tx\tdpse_m_wb\n";

while (<In>) {
next if ($_=~/Types/);
chomp;
my @temp=split (/\t/,$_);

my $w1118_f_ac=&median($temp[6],$temp[7],$temp[8],$temp[9]);
my $w1118_f_dg=&median($temp[10],$temp[11],$temp[12],$temp[13]);
my $w1118_f_ge=&median($temp[14],$temp[15],$temp[16],$temp[17]);
my $w1118_f_go=&median($temp[18],$temp[19],$temp[20],$temp[21]);
my $w1118_f_hd=&median($temp[22],$temp[23],$temp[24],$temp[25]);
my $w1118_f_re=&median($temp[26],$temp[27],$temp[28],$temp[29]);
my $w1118_f_tx=&median($temp[30],$temp[31],$temp[32],$temp[33]);
my $w1118_f_wb=&median($temp[34],$temp[35],$temp[36],$temp[37]);
my $w1118_m_ac=&median($temp[38],$temp[39],$temp[40],$temp[41]);
my $w1118_m_dg=&median($temp[42],$temp[43],$temp[44],$temp[45]);
my $w1118_m_ge=&median($temp[46],$temp[47],$temp[48],$temp[49]);
my $w1118_m_go=&median($temp[50],$temp[51],$temp[52],$temp[53]);
my $w1118_m_hd=&median($temp[54],$temp[55],$temp[56],$temp[57]);
my $w1118_m_re=&median($temp[58],$temp[59],$temp[60],$temp[61]);
my $w1118_m_tx=&median($temp[62],$temp[63],$temp[64],$temp[65]);
my $w1118_m_wb=&median($temp[66],$temp[67],$temp[68],$temp[69]);
my $oreR_f_ac=&median($temp[70],$temp[71],$temp[72],$temp[73]);
my $oreR_f_dg=&median($temp[74],$temp[75],$temp[76],$temp[77]);
my $oreR_f_ge=&median($temp[78],$temp[79],$temp[80],$temp[81]);
my $oreR_f_go=&median($temp[82],$temp[83],$temp[84],$temp[85]);
my $oreR_f_hd=&median($temp[86],$temp[87],$temp[88],$temp[89]);
my $oreR_f_re=&median($temp[90],$temp[91],$temp[92],$temp[93]);
my $oreR_f_tx=&median($temp[94],$temp[95],$temp[96],$temp[97]);
my $oreR_f_wb=&median($temp[98],$temp[99],$temp[100],$temp[101]);
my $oreR_m_ac=&median($temp[102],$temp[103],$temp[104],$temp[105]);
my $oreR_m_dg=&median($temp[106],$temp[107],$temp[108],$temp[109]);
my $oreR_m_ge=&median($temp[110],$temp[111],$temp[112],$temp[113]);
my $oreR_m_go=&median($temp[114],$temp[115],$temp[116],$temp[117]);
my $oreR_m_hd=&median($temp[118],$temp[119],$temp[120],$temp[121]);
my $oreR_m_re=&median($temp[122],$temp[123],$temp[124],$temp[125]);
my $oreR_m_tx=&median($temp[126],$temp[127],$temp[128],$temp[129]);
my $oreR_m_wb=&median($temp[130],$temp[131],$temp[132],$temp[133]);
my $dpse_f_ac=&median($temp[136],$temp[137],$temp[138],$temp[139]);
my $dpse_f_dg=&median($temp[140],$temp[141],$temp[142],$temp[143]);
my $dpse_f_go=&median($temp[144],$temp[145],$temp[146],$temp[147]);
my $dpse_f_hd=&median($temp[148],$temp[149],$temp[150],$temp[151]);
my $dpse_f_re=&median($temp[152],$temp[153],$temp[154],$temp[155]);
my $dpse_f_tx=&median($temp[156],$temp[157],$temp[158],$temp[159]);
my $dpse_f_wb=&median($temp[160],$temp[161],$temp[162],$temp[163]);
my $dpse_m_ac=&median($temp[164],$temp[165],$temp[166],$temp[167]);
my $dpse_m_dg=&median($temp[168],$temp[169],$temp[170],$temp[171]);
my $dpse_m_go=&median($temp[172],$temp[173],$temp[174],$temp[175]);
my $dpse_m_hd=&median($temp[176],$temp[177],$temp[178],$temp[179]);
my $dpse_m_re=&median($temp[180],$temp[181],$temp[182],$temp[183]);
my $dpse_m_tx=&median($temp[184],$temp[185],$temp[186],$temp[187]);
my $dpse_m_wb=&median($temp[188],$temp[189],$temp[190],$temp[191]);


print Out "$temp[0]\t$temp[4]\t$temp[1]\t$temp[2]\t$temp[3]\t$temp[135]\t$temp[192]\t$temp[193]\t$temp[194]\t$w1118_f_ac\t$w1118_f_dg\t$w1118_f_ge\t$w1118_f_go\t$w1118_f_hd\t$w1118_f_re\t$w1118_f_tx\t$w1118_f_wb\t$w1118_m_ac\t$w1118_m_dg\t$w1118_m_ge\t$w1118_m_go\t$w1118_m_hd\t$w1118_m_re\t$w1118_m_tx\t$w1118_m_wb\t$oreR_f_ac\t$oreR_f_dg\t$oreR_f_ge\t$oreR_f_go\t$oreR_f_hd\t$oreR_f_re\t$oreR_f_tx\t$oreR_f_wb\t$oreR_m_ac\t$oreR_m_dg\t$oreR_m_ge\t$oreR_m_go\t$oreR_m_hd\t$oreR_m_re\t$oreR_m_tx\t$oreR_m_wb\t$dpse_f_ac\t$dpse_f_dg\t$dpse_f_go\t$dpse_f_hd\t$dpse_f_re\t$dpse_f_tx\t$dpse_f_wb\t$dpse_m_ac\t$dpse_m_dg\t$dpse_m_go\t$dpse_m_hd\t$dpse_m_re\t$dpse_m_tx\t$dpse_m_wb\n";

}

sub median {
my $mean;
my ($n1,$n2,$n3,$n4) = @_;
my $median = ($n1+$n2+$n3+$n4)/4;
my $n1_bias = abs ($n1 - $median);
my $n2_bias = abs ($n2 - $median);
my $n3_bias = abs ($n3 - $median);
my $n4_bias = abs ($n4 - $median);
if ($n1_bias >=$n2_bias && $n1_bias >=$n3_bias && $n1_bias >=$n4_bias) {
$mean = ($n2+$n3+$n4)/3;
} elsif ($n2_bias >=$n1_bias && $n2_bias >=$n3_bias && $n2_bias >=$n4_bias) {
$mean = ($n1+$n3+$n4)/3;
} elsif ($n3_bias >=$n1_bias && $n3_bias >=$n2_bias && $n3_bias >=$n4_bias) {
$mean = ($n1+$n2+$n4)/3;
} elsif ($n4_bias >=$n1_bias && $n4_bias >=$n2_bias && $n4_bias >=$n3_bias) {
$mean = ($n1+$n2+$n3)/3;
} else {
$mean = $median;
}
return $mean;
}
