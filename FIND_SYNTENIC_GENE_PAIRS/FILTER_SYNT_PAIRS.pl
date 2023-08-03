open(IN1, $ARGV[0]); #PAIRS_LIST
open(OUT, ">$ARGV[0].$ARGV[1].FILTER.out");

my $repeat_max = $ARGV[1];
my $rep_counter = 0;
my @tempara = ();
my $first = 0;
my $curr = "";
my $prev = "";

while (my $line1=<IN1>){
	chomp $line1;
	$curr = $line1;
	my @parsed1 = split("\t", $line1);
	$curr = $parsed1[0];
	if ($first == 0){
		$first = 1;
		$prev = $curr;
	}
	if ($prev eq $curr){
		$rep_counter = $rep_counter + 1;
		print "REP COUNTED\n";
		push(@tempara, $line1);
	}
	if ($prev ne $curr){
		$length = @tempara;
		print "$length\n";
		if ($length <= $repeat_max){
			foreach $elem (@tempara){
				my @splitagain = split("\t", $elem);
				if ($splitagain[11] eq $splitagain[16]) {
					print OUT "$elem\n";
				}
			}
		}
		@tempara = ();
		$rep_counter = $rep_counter + 1;
		print "REP COUNTED\n";
		push(@tempara, $line1);
	}
	$prev = $curr;
}

$length = @tempara;
print "$length\n";
