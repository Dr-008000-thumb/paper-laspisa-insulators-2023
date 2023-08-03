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

print OUTA "module purge\n";
print OUTA "\nmodule load Cufflinks/2.2.1-foss-2019b\n";
print OUTA "cufflinks $ARGV[0] -u -o $ARGV[0].MULTI.READ.CORR\n";
print OUTA "cufflinks $ARGV[0] -o $ARGV[0].CUFF\n";
