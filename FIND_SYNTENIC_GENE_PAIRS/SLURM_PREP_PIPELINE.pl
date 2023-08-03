open(OUTA, ">$ARGV[0].slurm");

print OUTA "#!/bin/bash\n";
print OUTA "#SBATCH -J $ARGV[0]\n";
print OUTA "#SBATCH -p batch\n";
print OUTA "#SBATCH --ntasks=1\n";
print OUTA "#SBATCH --mem 20gb\n";
print OUTA "#SBATCH -t 05:00:00\n";
print OUTA "#SBATCH --output=$ARGV[0].%j.out\n";
print OUTA "#SBATCH -e $ARGV[0].%j.err\n";
print OUTA "#SBATCH --mail-type=NONE\n";
print OUTA '#SBATCH --mail-user djl35334@uga.edu';
print OUTA "\n\n";

print OUTA "mkdir $ARGV[5]\n";
print OUTA "cd $ARGV[5]\n";
print OUTA "cp ../$ARGV[0] .\n";
print OUTA "cp ../$ARGV[1] .\n";
print OUTA "cp ../$ARGV[2] .\n";
print OUTA "cp ../$ARGV[3] .\n";
print OUTA "cp ../$ARGV[4] .\n";
print OUTA "cp ../GET_MODEL_AND_CHR.pl .\n";
print OUTA "cp ../FIND_SYNTENIC_PAIRS.pl .\n";
print OUTA "cp ../FILTER_SYNT_PAIRS.pl .\n";
print OUTA "cp ../EXTRACT_SYNT_REGIONS.pl .\n";
print OUTA "cp ../ORIENT_SEQS_FOR_ALN.pl .\n";
print OUTA "cp ../MICROSYNTENY_SUPPORT.pl .\n";
print OUTA "cp ../fixfa.pl .\n";
print OUTA "cp ../PUTATIVE_CRE_LIST.txt .\n";

print OUTA "perl GET_MODEL_AND_CHR.pl $ARGV[0] $ARGV[1] $ARGV[2]\n";
#print OUTA "perl FIND_SYNTENIC_PAIRS.pl $ARGV[0].GFF.ADD.out 1\n";
#print OUTA "perl FIND_SYNTENIC_PAIRS.pl $ARGV[0].GFF.ADD.out 2\n";
#print OUTA "perl FIND_SYNTENIC_PAIRS.pl $ARGV[0].GFF.ADD.out 3\n";
#print OUTA "perl FIND_SYNTENIC_PAIRS.pl $ARGV[0].GFF.ADD.out 4\n";
print OUTA "perl FIND_SYNTENIC_PAIRS.pl $ARGV[0].GFF.ADD.out 5\n";
#print OUTA "perl FIND_SYNTENIC_PAIRS.pl $ARGV[0].GFF.ADD.out 6\n";
#print OUTA "perl FIND_SYNTENIC_PAIRS.pl $ARGV[0].GFF.ADD.out 7\n";
#print OUTA "perl FIND_SYNTENIC_PAIRS.pl $ARGV[0].GFF.ADD.out 8\n";
#print OUTA "perl FIND_SYNTENIC_PAIRS.pl $ARGV[0].GFF.ADD.out 9\n";
#print OUTA "perl FIND_SYNTENIC_PAIRS.pl $ARGV[0].GFF.ADD.out 10\n";

print OUTA "ls *.PAIRS.out | xargs -n 1 -I {} echo \"perl FILTER_SYNT_PAIRS.pl {} 10\" > FILTER.sh\n";
#print OUTA "perl FILTER_SYNT_PAIRS.pl $ARGV[0].GFF.ADD.out.5.PAIRS.out 10\n";
print OUTA "sh FILTER.sh\n";
print OUTA "ls *.FILTER.out | xargs -n 1 -I {} echo \"sort {} | uniq -u > {}.uniq.out\" > UNIQ.sh\n";
#print OUTA "sort $ARGV[0].GFF.ADD.out.5.PAIRS.out.10.FILTER.out | uniq -u > $ARGV[0].GFF.ADD.out.5.PAIRS.out.10.FILTER.uniq.out\n";
print OUTA "sh UNIQ.sh\n";
print OUTA "perl MICROSYNTENY_SUPPORT.pl $ARGV[0].GFF.ADD.out.5.PAIRS.out.10.FILTER.out.uniq.out PUTATIVE_CRE_LIST.txt\n";

#print OUTA "perl EXTRACT_SYNT_REGIONS.pl $ARGV[0].GFF.ADD.out.5.PAIRS.out.10.FILTER.out.uniq.out $ARGV[3] $ARGV[4]\n";
#print OUTA "ls CM0*.fa | xargs -n 1 -I {} echo \"perl ORIENT_SEQS_FOR_ALN.pl {} $ARGV[1] $ARGV[2]\" > ORI.sh\n";
#print OUTA "sh ORI.sh\n";
#print OUTA "module load MUSCLE/5.1-GCCcore-10.2.0\n";
#print OUTA "ls *ORI.fa | xargs -n 1 -I {} echo \"muscle -align {} -output {}.MUSCLE.fasta\" > ALN.sh\n";
#print OUTA "sh ALN.sh\n";
#print OUTA "ls *.fasta | xargs -n 1 -I {} echo \"perl fixfa.pl < {} > {}.fix.fasta\" > FIX.sh\n";
#print OUTA "sh FIX.sh\n";