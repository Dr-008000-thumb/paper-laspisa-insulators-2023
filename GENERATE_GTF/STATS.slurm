#!/bin/bash
#SBATCH -J STATS
#SBATCH -p batch
#SBATCH --ntasks=1
#SBATCH --mem 20gb
#SBATCH -t 05:00:00
#SBATCH --output=STATS.%j.out
#SBATCH -e STATS.%j.err
#SBATCH --mail-type=NONE
#SBATCH --mail-user djl35334@uga.edu

module load BackMap/0.5-foss-2019b-Perl-5.30.0

perl BASIC_STATS.pl ALL_COMBINED_1_MISMATCH_UNIQ_MAP.bam.dep.MAX.DP.3000.out