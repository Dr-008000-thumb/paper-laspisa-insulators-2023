open(GTF, $ARGV[0]) || die "Error: $!\n";
open(OUT, ">$ARGV[0].CRE.out");

my @data = ();
my $gene = "";
my $prev_gene = "";
my $fldchange = 0;
my $greater = 1;
my $smaller = 1;
my $flag = 0;
my $distance = 1000000;
my $median = $ARGV[1];

while(my $line=<GTF>){
	chomp $line;												#Loads the GTF into and array and removes newline characters
	#print "$line\n";
	push (@data, $line);
}

foreach $gene (@data){
	chomp $gene;
	#print "$gene\n";
	my @parsed1 = split ("\t", $prev_gene);									#six split statements parse the GTF file (cufflinks) into the current and previous entries for pairwise comparison
	my @parsed2 = split ("\t", $gene);

	my @temp1 = split (/;/, $parsed1[8]);
	my @temp2 = split (/;/, $parsed2[8]);

	my @FPKM1 = split (/ /, $temp1[2]);
	my @FPKM2 = split (/ /, $temp2[2]);

	my $US_FPKM = $parsed1[9];#swapped to use mean FPKM of all transcrripts with a matching gene id
	my $DS_FPKM = $parsed2[9];

	my @model1 = split (/ /, $temp1[0]);
	my @model2 = split (/ /, $temp2[0]);

	my $US_gene = substr ($model1[1], 1, -1);
	my $DS_gene = substr ($model2[1], 1, -1);


	#print "$US_FPKM\t$DS_FPKM\n";

	if ($US_FPKM > $DS_FPKM){										#two if statements compare the FPKM values for gene model pairs
		$greater = $US_FPKM;
		$smaller = $DS_FPKM;										#if FPKM1 is greather than the US gene has higher expression (SETS FLAG 1)
		$flag = 1;
	}
	if ($DS_FPKM > $US_FPKM){
		$greater = $DS_FPKM;										#if FPKM2 is greather than the DS gene has higher expression (SETS FLAG 2)
		$smaller = $US_FPKM;
		$flag = 2;
	}
	if (($US_FPKM > 0) && ($DS_FPKM > 0)){
		$fldchange = $greater / $smaller;								#calculates FPKM fold change
	}
	if (($US_FPKM eq "") || ($DS_FPKM eq "")){
		$fldchange = 0;											#Handles empty FPKM values
	}
	#print "$fldchange\n";

	$distance = $parsed2[3] - $parsed1[4];									#calculates distane between gene models

	if (($fldchange >= 1.5) && ($greater >= $median)){							#The FPKM fold change between gene modesl must be >=1.5 and the higher expressed model must have an FPKM >= the given median ($ARGV[1]))
		#print "here1\n";
		if (($distance <= 20000) && ($distance >= 1) && ($parsed1[0] eq $parsed2[0])){			#checks distance between gene models which must be non-overlapping and less than or equal to 20kb (~2 retrotransposon insertions) and requires both genes be on the same contig
			#print "here2\n";
			if (($parsed1[6] eq "+") && ($parsed2[6] eq "+")){		
				if ($flag == 1){								#both genes F orientation high expression in US gene (Terminator)
					print OUT "$parsed1[0]\t$parsed1[3]\t$parsed1[4]\t$parsed1[6]\t$US_gene\t$US_FPKM\t|\t$parsed2[0]\t$parsed2[3]\t$parsed2[4]\t$parsed2[6]\t$DS_gene\t$DS_FPKM\t|\t$parsed1[4]\t$parsed2[3]\t$fldchange\tTERMINATOR\n";
				}
				if ($flag == 2){								#both genes F orientation high expression in DS gene (Unidirectional Promoter)
					print OUT "$parsed1[0]\t$parsed1[3]\t$parsed1[4]\t$parsed1[6]\t$US_gene\t$US_FPKM\t|\t$parsed2[0]\t$parsed2[3]\t$parsed2[4]\t$parsed2[6]\t$DS_gene\t$DS_FPKM\t|\t$parsed1[4]\t$parsed2[3]\t$fldchange\tUNIDIRECTIONAL\n";
				}
			}
			if (($parsed1[6] eq "-") && ($parsed2[6] eq "-")){
				if ($flag == 1){								#both genes R orientation high expression in US gene (Paralell & US gene, Unidirectional Promoter)
					print OUT "$parsed1[0]\t$parsed1[3]\t$parsed1[4]\t$parsed1[6]\t$US_gene\t$US_FPKM\t|\t$parsed2[0]\t$parsed2[3]\t$parsed2[4]\t$parsed2[6]\t$DS_gene\t$DS_FPKM\t|\t$parsed1[4]\t$parsed2[3]\t$fldchange\tUNIDIRECTIONAL\n";
				}
				if ($flag == 2){								#both genes R orientation high expression in DS gene (Paralell & DS gene,Terminator)
					print OUT "$parsed1[0]\t$parsed1[3]\t$parsed1[4]\t$parsed1[6]\t$US_gene\t$US_FPKM\t|\t$parsed2[0]\t$parsed2[3]\t$parsed2[4]\t$parsed2[6]\t$DS_gene\t$DS_FPKM\t|\t$parsed1[4]\t$parsed2[3]\t$fldchange\tTERMINATOR\n";
				}				
			}
			if (($parsed1[6] eq "+") && ($parsed2[6] eq "-")){
				if ($flag == 1){								#US gene F orientation, DS gene R orientation high expression in US gene (Convergent & US, Terminator)
					print OUT "$parsed1[0]\t$parsed1[3]\t$parsed1[4]\t$parsed1[6]\t$US_gene\t$US_FPKM\t|\t$parsed2[0]\t$parsed2[3]\t$parsed2[4]\t$parsed2[6]\t$DS_gene\t$DS_FPKM\t|\t$parsed1[4]\t$parsed2[3]\t$fldchange\tTERMINATOR_INSULATOR\n";
				}
				if ($flag == 2){								#US gene F orientation, DS gene R orientation high expression in DS gene (Convergent & DS, Terminator)
					print OUT "$parsed1[0]\t$parsed1[3]\t$parsed1[4]\t$parsed1[6]\t$US_gene\t$US_FPKM\t|\t$parsed2[0]\t$parsed2[3]\t$parsed2[4]\t$parsed2[6]\t$DS_gene\t$DS_FPKM\t|\t$parsed1[4]\t$parsed2[3]\t$fldchange\tTERMINATOR_INSULATOR\n";
				}				
			}
			if (($parsed1[6] eq "-") && ($parsed2[6] eq "+")){
				if ($flag == 1){								#US gene R orientation, DS gene F orientation high expression in US gene (Divergent & US, Insulator)
					print OUT "$parsed1[0]\t$parsed1[3]\t$parsed1[4]\t$parsed1[6]\t$US_gene\t$US_FPKM\t|\t$parsed2[0]\t$parsed2[3]\t$parsed2[4]\t$parsed2[6]\t$DS_gene\t$DS_FPKM\t|\t$parsed1[4]\t$parsed2[3]\t$fldchange\tINSULATOR\n";
				}
				if ($flag == 2){								#US gene R orientation, DS gene F orientation high expression in DS gene (Divergent & DS, Insulator)
					print OUT "$parsed1[0]\t$parsed1[3]\t$parsed1[4]\t$parsed1[6]\t$US_gene\t$US_FPKM\t|\t$parsed2[0]\t$parsed2[3]\t$parsed2[4]\t$parsed2[6]\t$DS_gene\t$DS_FPKM\t|\t$parsed1[4]\t$parsed2[3]\t$fldchange\tINSULATOR\n";
				}				
			}
			
			
						if (($parsed1[6] eq ".") && ($parsed2[6] eq "+")){
				if ($flag == 1){								#US gene ? orientation, DS gene F orientation high expression in US gene
					print OUT "$parsed1[0]\t$parsed1[3]\t$parsed1[4]\t$parsed1[6]\t$US_gene\t$US_FPKM\t|\t$parsed2[0]\t$parsed2[3]\t$parsed2[4]\t$parsed2[6]\t$DS_gene\t$DS_FPKM\t|\t$parsed1[4]\t$parsed2[3]\t$fldchange\tPUT_CRE_3PF_US\n";
				}
				if ($flag == 2){								#US gene ? orientation, DS gene F orientation high expression in DS gene
					print OUT "$parsed1[0]\t$parsed1[3]\t$parsed1[4]\t$parsed1[6]\t$US_gene\t$US_FPKM\t|\t$parsed2[0]\t$parsed2[3]\t$parsed2[4]\t$parsed2[6]\t$DS_gene\t$DS_FPKM\t|\t$parsed1[4]\t$parsed2[3]\t$fldchange\tPUT_CRE_3PF_DS\n";
				}				
			}
						if (($parsed1[6] eq "+") && ($parsed2[6] eq ".")){
				if ($flag == 1){								#US gene F orientation, DS gene ? orientation high expression in US gene
					print OUT "$parsed1[0]\t$parsed1[3]\t$parsed1[4]\t$parsed1[6]\t$US_gene\t$US_FPKM\t|\t$parsed2[0]\t$parsed2[3]\t$parsed2[4]\t$parsed2[6]\t$DS_gene\t$DS_FPKM\t|\t$parsed1[4]\t$parsed2[3]\t$fldchange\tPUT_CRE_5PF_US\n";
				}
				if ($flag == 2){								#US gene R orientation, DS gene ? orientation high expression in DS gene
					print OUT "$parsed1[0]\t$parsed1[3]\t$parsed1[4]\t$parsed1[6]\t$US_gene\t$US_FPKM\t|\t$parsed2[0]\t$parsed2[3]\t$parsed2[4]\t$parsed2[6]\t$DS_gene\t$DS_FPKM\t|\t$parsed1[4]\t$parsed2[3]\t$fldchange\tPUT_CRE_5PF_DS\n";
				}				
			}
						if (($parsed1[6] eq ".") && ($parsed2[6] eq "-")){
				if ($flag == 1){								#US gene ? orientation, DS gene R orientation high expression in US gene
					print OUT "$parsed1[0]\t$parsed1[3]\t$parsed1[4]\t$parsed1[6]\t$US_gene\t$US_FPKM\t|\t$parsed2[0]\t$parsed2[3]\t$parsed2[4]\t$parsed2[6]\t$DS_gene\t$DS_FPKM\t|\t$parsed1[4]\t$parsed2[3]\t$fldchange\tPUT_CRE_3PR_US\n";
				}
				if ($flag == 2){								#US gene ? orientation, DS gene R orientation high expression in DS gene
					print OUT "$parsed1[0]\t$parsed1[3]\t$parsed1[4]\t$parsed1[6]\t$US_gene\t$US_FPKM\t|\t$parsed2[0]\t$parsed2[3]\t$parsed2[4]\t$parsed2[6]\t$DS_gene\t$DS_FPKM\t|\t$parsed1[4]\t$parsed2[3]\t$fldchange\tPUT_CRE_3PR_DS\n";
				}				
			}
						if (($parsed1[6] eq "-") && ($parsed2[6] eq ".")){
				if ($flag == 1){								#US gene R orientation, DS gene ? orientation high expression in US gene
					print OUT "$parsed1[0]\t$parsed1[3]\t$parsed1[4]\t$parsed1[6]\t$US_gene\t$US_FPKM\t|\t$parsed2[0]\t$parsed2[3]\t$parsed2[4]\t$parsed2[6]\t$DS_gene\t$DS_FPKM\t|\t$parsed1[4]\t$parsed2[3]\t$fldchange\tPUT_CRE_5PR_US\n";
				}
				if ($flag == 2){								#US gene R orientation, DS gene ? orientation high expression in DS gene
					print OUT "$parsed1[0]\t$parsed1[3]\t$parsed1[4]\t$parsed1[6]\t$US_gene\t$US_FPKM\t|\t$parsed2[0]\t$parsed2[3]\t$parsed2[4]\t$parsed2[6]\t$DS_gene\t$DS_FPKM\t|\t$parsed1[4]\t$parsed2[3]\t$fldchange\tPUT_CRE_5PR_DS\n";
				}				
			}

		}
	}

	if (($fldchange <= 1.5) && ($distance >= 1) && ($greater >= $median) && ($smaller >= $median) && ($distance <= 20000) && ($parsed1[0] eq $parsed2[0])){	#The genes are on the same contig but do not meet the fold change threshold but both have expression higher than the given median and are <=20kb (~2 retrotransposon insertions) apart
		if (($parsed1[6] eq "-") && ($parsed2[6] eq "+")){						#The genes both have expresion higher than the median in opposiing orientations (Bidirectional)
			print OUT "$parsed1[0]\t$parsed1[3]\t$parsed1[4]\t$parsed1[6]\t$US_gene\t$US_FPKM\t|\t$parsed2[0]\t$parsed2[3]\t$parsed2[4]\t$parsed2[6]\t$DS_gene\t$DS_FPKM\t|\t$parsed1[4]\t$parsed2[3]\t$fldchange\tBIDIRECTIONAL\n";
		}
	}
	$prev_gene = $gene;
	$flag = 0;
}

