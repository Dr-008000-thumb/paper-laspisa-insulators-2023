open(FASTA1, $ARGV[0]) || die "Error: $!\n";
open(EXLST1, $ARGV[1]) || die "Error: $!\n";
open(EXLST2, $ARGV[2]) || die "Error: $!\n";

open(OUT, ">$ARGV[0].ORI.fa");

my @headers;
my @seqs;
my @data;
my @ori =();
my $counter = 0;
my $flag1 = 0;
my $flag2 = 0;

while(my $line0 = <EXLST1>){
	chomp $line0;
	push(@data, $line0);
}

while(my $line2 = <EXLST2>){
	chomp $line2;
	push(@data, $line2);
}

while(my $line1 = <FASTA1>){
	chomp $line1;
	if($line1 =~ /^>+/) {
		$line1 =~ s/^.//; #removes first character
		push(@headers, $line1);
	}
	else{
		push(@seqs, $line1);
	}
}

foreach $head (@headers){
	chomp $head;
	print "$head\n";
	my @temp = split("-", $head);
	my $model1 = $temp[1];
	my $model2 = $temp[2];
	print "$model1\t$model2\n";
	foreach $entry (@data){
		my @temp1 = split("\t", $entry);
		my @temp2 = split(";", $entry);
		my @chk = split("=", $temp2[0]);
		my @chk1 = split("-", $chk[1]);
		if ($flag1 == 0){
			if (($model1 eq $chk1[1]) || ($model1 eq $chk1[0])){
				print "model1_ori\n";
				push(@ori, $temp1[6]);
				$flag1 = 1;
			}
		}
		if ($flag2 == 0){
			if (($model2 eq $chk1[1]) || ($model2 eq $chk1[0])){
				print "model2_ori\n";
				push(@ori, $temp1[6]);
				$flag2 = 1;
			}
		}
	}
	$flag1 = 0;
	$flag2 = 0;
}

print "$ori[0]\t$ori[1]\t$ori[2]\t$ori[3]\n";

my $pair1 = $ori[0].$ori[1];
my $pair2 = $ori[2].$ori[3];

print "$pair1\t$pair2\n";

if ($pair1 eq $pair2){
	print OUT ">$headers[0].$pair1\n$seqs[0]\n>$headers[1].$pair2\n$seqs[1]\n";
}
if ($pair1 ne $pair2){
	if (($pair1 eq "+-") && ($pair2 eq "-+")){
		my $revcomp = reverse $seqs[0];
		$revcomp =~ tr/ATGCatgc/TACGtacg/;
		print OUT ">$headers[0].$pair1.REV\n$revcomp\n>$headers[1].$pair2\n$seqs[1]\n";
	}
	if (($pair1 eq "-+") && ($pair2 eq "+-")){
		my $revcomp = reverse $seqs[0];
		$revcomp =~ tr/ATGCatgc/TACGtacg/;
		print OUT ">$headers[0].$pair1.REV\n$revcomp\n>$headers[1].$pair2\n$seqs[1]\n";
	}
	if (($pair1 eq "++") && ($pair2 eq "--")){
		my $revcomp = reverse $seqs[0];
		$revcomp =~ tr/ATGCatgc/TACGtacg/;
		print OUT ">$headers[0].$pair1.REV\n$revcomp\n>$headers[1].$pair2\n$seqs[1]\n";
	}
	if (($pair1 eq "--") && ($pair2 eq "++")){
		my $revcomp = reverse $seqs[0];
		$revcomp =~ tr/ATGCatgc/TACGtacg/;
		print OUT ">$headers[0].$pair1.REV\n$revcomp\n>$headers[1].$pair2\n$seqs[1]\n";
	}



	if (($pair1 eq "++") && ($pair2 eq "+-")){
		print OUT ">$headers[0].$pair1.LOW_CONF\n$seqs[0]\n>$headers[1].$pair2.LOW_CONF\n$seqs[1]\n";
	}
	if (($pair1 eq "++") && ($pair2 eq "-+")){
		print OUT ">$headers[0].$pair1.LOW_CONF\n$seqs[0]\n>$headers[1].$pair2.LOW_CONF\n$seqs[1]\n";
	}

	if (($pair1 eq "+-") && ($pair2 eq "--")){
		print OUT ">$headers[0].$pair1.LOW_CONF\n$seqs[0]\n>$headers[1].$pair2.LOW_CONF\n$seqs[1]\n";
	}
	if (($pair1 eq "-+") && ($pair2 eq "--")){
		print OUT ">$headers[0].$pair1.LOW_CONF\n$seqs[0]\n>$headers[1].$pair2.LOW_CONF\n$seqs[1]\n";
	}

	if (($pair1 eq "--") && ($pair2 eq "-+")){
		print OUT ">$headers[0].$pair1.LOW_CONF\n$seqs[0]\n>$headers[1].$pair2.LOW_CONF\n$seqs[1]\n";
	}
	if (($pair1 eq "--") && ($pair2 eq "+-")){
		print OUT ">$headers[0].$pair1.LOW_CONF\n$seqs[0]\n>$headers[1].$pair2.LOW_CONF\n$seqs[1]\n";
	}

	if (($pair1 eq "-+") && ($pair2 eq "++")){
		print OUT ">$headers[0].$pair1.LOW_CONF\n$seqs[0]\n>$headers[1].$pair2.LOW_CONF\n$seqs[1]\n";
	}
	if (($pair1 eq "+-") && ($pair2 eq "++")){
		print OUT ">$headers[0].$pair1.LOW_CONF\n$seqs[0]\n>$headers[1].$pair2.LOW_CONF\n$seqs[1]\n";
	}

}
