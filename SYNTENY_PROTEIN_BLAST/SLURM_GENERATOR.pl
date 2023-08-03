open(OUTA, ">$ARGV[0].slurm");

print OUTA "#!/bin/bash\n";
print OUTA "#SBATCH -J $ARGV[0]\n";
print OUTA "#SBATCH -p batch\n";
print OUTA "#SBATCH --ntasks=10\n";
print OUTA "#SBATCH --mem 20gb\n";
print OUTA "#SBATCH -t 05:00:00\n";
print OUTA "#SBATCH --output=$ARGV[0].%j.out\n";
print OUTA "#SBATCH -e $ARGV[0].%j.err\n";
print OUTA "#SBATCH --mail-type=NONE\n";
print OUTA '#SBATCH --mail-user djl35334@uga.edu';
print OUTA "\n\n";

print OUTA "module load BLAST+/2.2.31\n";
print OUTA "makeblastdb -in $ARGV[0] -parse_seqids -dbtype prot\n";
print OUTA "blastp -query ALL_COMBINED_1_MISMATCH_UNIQ_MAP.FILTER.GT3000.bam.MULTI.READ.CORR.TRANSDECODER.PROT.FIX_HEADER.fix.fa -db $ARGV[0] -evalue 1e-5 -num_threads 10 -outfmt 6 > U.GIBBA_to_$ARGV[0].blast\n";
