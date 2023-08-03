open(IN1, $ARGV[0]); #BLAST
open(IN2, $ARGV[1]); #UG_GFF
open(IN3, $ARGV[2]); #OTHER_GFF

open(OUT, ">$ARGV[0].GFF.ADD.out");

my %hash_UG;
my %hash_other;

while (my $line2=<IN2>){
	chomp $line2;
	my @parsed2 = split ("\t", $line2);
	my @parsed2_x = split (";", $parsed2[8]);
	my @parsed2_xx = split ("=", $parsed2_x[0]);
	#print "$parsed2_xx[1]\n";
	$hash_UG{$parsed2_xx[1]} = $line2;
}

while (my $line3=<IN3>){
	chomp $line3;
	my @parsed3 = split ("\t", $line3);
	my @parsed3_x = split (";", $parsed3[8]);
	my @parsed3_xx = split ("-", $parsed3_x[0]);
	#print "$parsed3_xx[1]\n";
	$hash_other{$parsed3_xx[1]} = $line3;
}

while (my $line1=<IN1>){
	chomp $line1;
	my $out1 = "";
	my $out2 = "";
	my @parsed1 = split ("\t", $line1);
	if(exists $hash_UG{$parsed1[0]}){
		$out1 = $hash_UG{$parsed1[0]};
		#print "HERE1\n";
	}
	if(exists $hash_other{$parsed1[1]}){
		$out2 = $hash_other{$parsed1[1]};
		#print "HERE2\n";
	}
	print OUT "$line1\t$out1\t$out2\n";
}
