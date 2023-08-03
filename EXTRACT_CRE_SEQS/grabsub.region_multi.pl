open(FASTA, $ARGV[1]) || die "Error: $!\n";
open(EXLST, $ARGV[0]) || die "Error: $!\n";
my $header = "no_header";
my $seq = "";
my @headers;
my @seqs;
my $counter =0;
my $length = 0;
my $extraction = "";

while(my $line = <FASTA>){
	chomp $line;
	if($line =~ /^>+/) {
		$line =~ s/^.//; #removes first character
		push(@headers, $line);
	}
	else{
		push(@seqs, $line);

	}

}

while(my $file = <EXLST>){
	chomp $file;
	my @exdata = split("\t", $file);
	$counter = 0;
	foreach $id (@headers){
		if($exdata[0] eq $id){
			$length = $exdata[2] - $exdata[1];
			$extraction = substr $seqs[$counter], $exdata[1], $length;
			print(">$id\t$exdata[1]\t$exdata[2]\t$extraction\n");
		}
		$counter = $counter + 1;
	}
}