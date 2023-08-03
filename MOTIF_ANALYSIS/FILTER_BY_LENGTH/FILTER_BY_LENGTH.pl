open(IN, $ARGV[0]);

my @id;
my @seqs;

my $print_out = "";

while (my $line=<IN>){
	chomp $line;
	if ($line =~ /\>/) { #if has fasta >
		$print_out = $line
	}
	else{
		my $size = length($line);
		#print "$size\n";
		if ($size <= $ARGV[1]){
			print "$print_out\n$line\n";
		} 
	}
}