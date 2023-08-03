open(IN, $ARGV[0]);

while (my $line=<IN>){
	chomp $line;
	if ($line =~ /\>/) {
		my @dat_line1 = split (' ', $line);
		my @dat_line2 = split (/\./, $dat_line1[2]);
		print ">$dat_line2[0].$dat_line2[1] .$dat_line2[2].$dat_line2[3]\n";
	}
	else{
		print "$line\n"; 
	}
}