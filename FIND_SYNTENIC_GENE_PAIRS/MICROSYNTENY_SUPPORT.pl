open(DATA, $ARGV[0]);
open(CHK, $ARGV[1]);
open(OUT, ">$ARGV[0].$ARGV[1].out");

my @pairs = ();
my $chk_start = 0;
my $chk_stop = 0;
my $chk_chr = "";
my $ori1 = "NA";
my $ori2 = "NA";
my $ori3 = "NA";
my $ori4 = "NA";

my $UG_gene_diff = 0;
my $subj_gene_diff = 0;

while (my $line1=<DATA>){
	chomp $line1;
	push(@pairs, $line1);
}

while (my $line2=<CHK>){
	chomp $line2;
	my @chk_parse = split("\t", $line2);
	
	$chk_start = $chk_parse[1];
	$chk_stop = $chk_parse[2];
	$chk_chr = $chk_parse[0];

	foreach $group (@pairs){
		chomp $group;
		my @group_parse = split("\t", $group);
		$ori1 = $group_parse[4];
		$ori2 = $group_parse[9];
		$ori3 = $group_parse[14];
		$ori4 = $group_parse[19];
		$UG_group_chr = $group_parse[1];
		$UG_group_start = $group_parse[2];
		$UG_group_end = $group_parse[8];

		my @ug_gene1 = split(/\./, $group_parse[0]);
		my $temp1 = $ug_gene1[1];
		my @ug_gene2 = split(/\./, $group_parse[5]);
		my $temp2 = $ug_gene2[1];
		$UG_gene_diff = $temp2 - $temp1;

		my @subj_gene1 = split(/\./, $group_parse[10]);
		my @subtemp1 = split("_", $subj_gene1[0]);
		my $temp1 = $subtemp1[1];
		my @subj_gene2 = split(/\./, $group_parse[15]);
		my @subtemp2 = split("_", $subj_gene2[0]);
		my $temp2 = $subtemp2[1];
		if ($temp1 > $temp2){
			$subj_gene_diff = $temp1 - $temp2;
		}
		if ($temp2 > $temp1){
			$subj_gene_diff = $temp2 - $temp1;
		}
		
		#print "$UG_gene_diff\t$subj_gene_diff\n";

		if(($ori1 eq $ori3) && ($ori2 eq $ori4)){						#if the orientation is conserved in the group
			if($chk_chr eq $UG_group_chr){							#if the chromosome matches for the putative CRE and microsyntenic group
				if(($chk_start >= $UG_group_start) && ($chk_stop <= $UG_group_end)){	#if the putative CRE coordiantes are within the coordinates of the microsynttenic group in U gibba
					if($subj_gene_diff == $UG_gene_diff){				#if the number of genes between the pair of subject genes (non-u.gibba) is the same number of genes between the u. gibba pair (ie. no evidence of gene deletion) 
						print OUT "$line2\tHI\n";
					}
				}
			}
		}
		if(($ori1 ne $ori3) && ($ori2 ne $ori4)){						#if the orientation is reversed in the group
			if($chk_chr eq $UG_group_chr){							#if the chromosome matches for the putative CRE and microsyntenic group
				if(($chk_start >= $UG_group_start) && ($chk_stop <=$UG_group_end)){	#if the putative CRE coordiantes are within the coordinates of the microsynttenic group in U gibba
					if($subj_gene_diff == $UG_gene_diff){				#if the number of genes between the pair of subject genes (non-u.gibba) is the same number of genes between the u. gibba pair (ie. no evidence of gene deletion) 
						print OUT "$line2\tHI\n";
					}
				}
			}
		}
		if(($ori1 eq $ori3) && ($ori2 eq $ori4)){						#if the orientation is conserved in the group
			if($chk_chr eq $UG_group_chr){							#if the chromosome matches for the putative CRE and microsyntenic group
				if(($chk_start >= $UG_group_start) && ($chk_stop <= $UG_group_end)){	#if the putative CRE coordiantes are within the coordinates of the microsynttenic group in U gibba
					if($subj_gene_diff >= $UG_gene_diff){				#if the number of genes between the pair of subject genes (non-u.gibba) is >= the number of genes between the u. gibba pair (ie. no evidence of gene deletion) 
						print OUT "$line2\tDI\n";
					}
				}
			}
		}
		if(($ori1 ne $ori3) && ($ori2 ne $ori4)){						#if the orientation is reversed in the group
			if($chk_chr eq $UG_group_chr){							#if the chromosome matches for the putative CRE and microsyntenic group
				if(($chk_start >= $UG_group_start) && ($chk_stop <=$UG_group_end)){	#if the putative CRE coordiantes are within the coordinates of the microsynttenic group in U gibba
					if($subj_gene_diff >= $UG_gene_diff){				#if the number of genes between the pair of subject genes (non-u.gibba) is >= the number of genes between the u. gibba pair (ie. no evidence of gene deletion) 
						print OUT "$line2\tDI\n";
					}
				}
			}
		}

		if(($ori1 eq $ori3) && ($ori2 eq $ori4)){						#if the orientation is conserved in the group
			if($chk_chr eq $UG_group_chr){							#if the chromosome matches for the putative CRE and microsyntenic group
				if(($chk_start >= $UG_group_start) && ($chk_stop <= $UG_group_end)){	#if the putative CRE coordiantes are within the coordinates of the microsynttenic group in U gibba
					if($subj_gene_diff <= $UG_gene_diff){				#if the number of genes between the pair of subject genes (non-u.gibba) is <= the number of genes between the u. gibba pair (ie. potential gene deletion) 
						print OUT "$line2\tDI\n";
					}
				}
			}
		}
		if(($ori1 ne $ori3) && ($ori2 ne $ori4)){						#if the orientation is reversed in the group
			if($chk_chr eq $UG_group_chr){							#if the chromosome matches for the putative CRE and microsyntenic group
				if(($chk_start >= $UG_group_start) && ($chk_stop <=$UG_group_end)){	#if the putative CRE coordiantes are within the coordinates of the microsynttenic group in U gibba
					if($subj_gene_diff <= $UG_gene_diff){				#if the number of genes between the pair of subject genes (non-u.gibba) is <= the number of genes between the u. gibba pair (ie. potential gene deletion) 
						print OUT "$line2\tDI\n";
					}
				}
			}
		}
		if(($ori1 eq $ori3) && ($ori2 ne $ori4)){						#if the orientation is different (potential inversion)
			if($chk_chr eq $UG_group_chr){							#if the chromosome matches for the putative CRE and microsyntenic group
				if(($chk_start >= $UG_group_start) && ($chk_stop <= $UG_group_end)){	#if the putative CRE coordiantes are within the coordinates of the microsynttenic group in U gibba
					if($subj_gene_diff >= $UG_gene_diff){				#if the number of genes between the pair of subject genes (non-u.gibba) is >= the number of genes between the u. gibba pair (ie. no evidence of gene deletion) 
						print OUT "$line2\tIV\n";
					}
				}
			}
		}
		if(($ori1 ne $ori3) && ($ori2 eq $ori4)){						#if the orientation is different (potential inversion)
			if($chk_chr eq $UG_group_chr){							#if the chromosome matches for the putative CRE and microsyntenic group
				if(($chk_start >= $UG_group_start) && ($chk_stop <=$UG_group_end)){	#if the putative CRE coordiantes are within the coordinates of the microsynttenic group in U gibba
					if($subj_gene_diff >= $UG_gene_diff){				#if the number of genes between the pair of subject genes (non-u.gibba) is >= the number of genes between the u. gibba pair (ie. no evidence of gene deletion) 
						print OUT "$line2\tIV\n";
					}
				}
			}
		}


	}
}