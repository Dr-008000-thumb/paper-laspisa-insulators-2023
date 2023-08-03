open(IN1, $ARGV[0]); #BLAST
open(OUT, ">$ARGV[0].$ARGV[1].PAIRS.out");

my $inter_genes = $ARGV[1];

my $curr = "";
my $prev = "";
my $start_flag = 1;
my $pair_flag = 1;
my $set = "";

my @ug_gene1_lst = ();
my @ug_gene2_lst = ();

while (my $line1=<IN1>){
	chomp $line1;
	$curr = $line1;
	my @parsed1 = split ("\t", $curr);
	my @parsed2 = split ("\t", $prev);

	if ($start_flag == 1){ 								#first line
		$start_flag = 0;
		$prev = $curr;
		@parsed2 = split ("\t", $prev);
		push (@ug_gene1_lst, $parsed1[1]);
	}

	if ($parsed1[0] eq $parsed2[0]){ 						#same UG gene model
		if ($pair_flag == 1){
			push (@ug_gene1_lst, $curr);
			print "GENE1 LIST ADDED\n";
		}
		if ($pair_flag == 2){
			push (@ug_gene2_lst, $curr);
			print "GENE2 LIST ADDED\n";
		}
	}

	if ($parsed1[0] ne $parsed2[0]){ 						#different UG gene model
		@ugibba_dist_chk2 = split(/\./, $parsed2[0]);
		@ugibba_dist_chk1 = split(/\./, $parsed1[0]);
		if ($pair_flag == 1){
			print "PAIR_FLAG SET TO 2\n";
			$set = $prev;
			$set2 = $curr;
			$pair_flag = 2;
			push (@ug_gene2_lst, $curr);
		}
		if ($pair_flag == 2){
			print "$ugibba_dist_chk1[1]\t$ugibba_dist_chk2[1]\n";
			if (abs($ugibba_dist_chk1[1] - $ugibba_dist_chk2[1]) != 1){
				foreach $gene1 (@ug_gene1_lst){
					my @tempx1 = split ("\t", $gene1);
					my $temp1 = substr($tempx1[1], 3);
					my $gene_num1 = substr($temp1, 0, -2);
					foreach $gene2 (@ug_gene2_lst){
						my @tempx2 = split ("\t", $gene2);
						my $temp2 = substr($tempx2[1], 3);
						my $gene_num2 = substr($temp2, 0, -2);
						if (abs($gene_num1 - $gene_num2) <= $inter_genes){
							print "FINAL PRINT $gene_num1 $gene_num2\n";
							@tempset = split ("\t", $set);
							print OUT "$tempset[0]\t$tempset[12]\t$tempset[15]\t$tempset[16]\t$tempset[18]\t$parsed2[0]\t$parsed2[12]\t$parsed2[15]\t$parsed2[16]\t$parsed2[18]\t$tempx1[1]\t$tempx1[21]\t$tempx1[24]\t$tempx1[25]\t$tempx1[27]\t$tempx2[1]\t$tempx2[21]\t$tempx2[24]\t$tempx2[25]\t$tempx2[27]\n";
						}
					}
				}
				$pair_flag = 1;
				@ug_gene1_lst = ();
				@ug_gene2_lst = ();
				push (@ug_gene1_lst, $curr);

			}
			if (abs($ugibba_dist_set[1] - $ugibba_dist_chk2[1]) == 1){
				#sprint "HERE\n";
				push (@ug_gene2_lst, $curr);
				#print "GENE2 LIST ADDED\n";
			}
		}
	}
	$prev = $curr;
}

foreach $gene1 (@ug_gene1_lst){
	my @tempx1 = split ("\t", $gene1);
	my $temp1 = substr($tempx1[1], 3);
	my $gene_num1 = substr($temp1, 0, -2);
	foreach $gene2 (@ug_gene2_lst){
		my @tempx2 = split ("\t", $gene2);
		my $temp2 = substr($tempx2[1], 3);
		my $gene_num2 = substr($temp2, 0, -2);
		if (abs($gene_num1 - $gene_num2) <= $inter_genes){
			print "FINAL PRINT $gene_num1 $gene_num2\n";
			@tempset = split ("\t", $set);
			@tempset2 = split ("\t", $set2);
			print OUT "$tempset[0]\t$tempset[12]\t$tempset[15]\t$tempset[16]\t$tempset2[0]\t$tempset2[12]\t$tempset2[15]\t$tempset2[16]\t$tempx1[1]\t$tempx1[21]\t$tempx1[24]\t$tempx1[25]\t$tempx2[1]\t$tempx2[21]\t$tempx2[24]\t$tempx2[25]\n";
		}
	}
}