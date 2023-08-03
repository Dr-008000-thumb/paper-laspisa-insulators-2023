open(FASTA2, $ARGV[2]) || die "Error: $!\n";
open(FASTA1, $ARGV[1]) || die "Error: $!\n";
open(EXLST, $ARGV[0]) || die "Error: $!\n";

use List::Util qw( min max );

my $header = "no_header";
my $seq = "";
my @headers;
my @seqs;
my $counter =0;
my $length = 0;
my $extraction = "";

while(my $line1 = <FASTA1>){
	chomp $line1;
	if($line1 =~ /^>+/) {
		$line1 =~ s/^.//; #removes first character
		my @headsplit1 = split(' ', $line1);
		push(@headers, $headsplit1[0]);
	}
	else{
		push(@seqs, $line1);
	}
}

while(my $line2 = <FASTA2>){
	chomp $line2;
	if($line2 =~ /^>+/) {
		$line2 =~ s/^.//; #removes first character
		my @headsplitb = split("_", $line2);
		push(@headers, $headsplitb[0]);
	}
	else{
		push(@seqs, $line2);
	}
}

while(my $file = <EXLST>){
	chomp $file;
	my @exdata = split("\t", $file);

	my $header1 = $exdata[1];
	my $id1a = $exdata[0];
	my $id1b = $exdata[4];

	my $header2 = $exdata[9];
	my $id2a = $exdata[8];
	my $id2b = $exdata[12];

	my @coords = ();
	push(@coords, $exdata[2]);
	push(@coords, $exdata[3]);
	push(@coords, $exdata[6]);
	push(@coords, $exdata[7]);

	@sorted_coords = sort { $a <=> $b } @coords;

	my $start1 = min @sorted_coords;
	my $stop1 = max @sorted_coords;
	my $ex_start1 = $sorted_coords[1];
	my $ex_stop1 = $sorted_coords[2];

	my @coords = ();
	push(@coords, $exdata[10]);
	push(@coords, $exdata[11]);
	push(@coords, $exdata[14]);
	push(@coords, $exdata[15]);

	@sorted_coords = sort { $a <=> $b } @coords;

	my $start2 = min @sorted_coords;
	my $stop2 = max @sorted_coords;
	my $ex_start2 = $sorted_coords[1];
	my $ex_stop2 = $sorted_coords[2];


	print "$start1\t$stop1\t$start2\t$stop2\n";

	$counter = 0;
	open(OUT, ">$header1-$id1a-$id1b-$start1-$stop1..$header2-$id2a-$id2b-$start2-$stop2.fa");

	foreach $ident (@headers){		#Only extracting the intergenic region between the two syntenic gene models
		if($header1 eq $ident){
			$length = $ex_stop1 - $ex_start1;
			$extraction = substr $seqs[$counter], $ex_start1, $length;
			print OUT (">$header1-$id1a-$id1b-$start1-$stop1-$ex_start1-$ex_stop1\n$extraction\n");
		}
		if($header2 eq $ident){
			$length = $ex_stop2 - $ex_start2;
			$extraction = substr $seqs[$counter], $ex_start2, $length;
			print OUT (">$header2-$id2a-$id2b-$start2-$stop2-$ex_start2-$ex_stop2\n$extraction\n");
		}
		$counter = $counter + 1;
	}
}

close OUT;