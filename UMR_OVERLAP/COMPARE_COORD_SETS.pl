open(CR, $ARGV[0]);
open(UMR, $ARGV[1]);

my @CR_data;
my $us_coord= 0;
my $ds_coord = 0;

while ($data = <CR>){
	chomp $data;
	push (@CR_data, $data);
	#print "$data\n";
}


while (my $line=<UMR>){
	chomp $line;
	#print "$line\n";
	my @splitUMR = split("\t", $line);
	foreach $elem (@CR_data){
		chomp $elem;
		my @splitCR = split("\t", $elem);
		#print "$splitCR[0] eq $splitUMR[0]\n";
		if ($splitCR[0] eq $splitUMR[0]){ #same chromosome
			#print "1\n";
			if (($splitUMR[1] <= $splitCR[1]) && ($splitUMR[2] >= $splitCR[2])){ #CRE is contained within UMR
				print "$line\t$elem\n";
			}
		}
	}
}