#!/bin/bash
#SBATCH -J Daucus_carota.GCF_001625215.1.PROTEIN.fix.fa
#SBATCH -p batch
#SBATCH --ntasks=10
#SBATCH --mem 20gb
#SBATCH -t 05:00:00
#SBATCH --output=Daucus_carota.GCF_001625215.1.PROTEIN.fix.fa.%j.out
#SBATCH -e Daucus_carota.GCF_001625215.1.PROTEIN.fix.fa.%j.err
#SBATCH --mail-type=NONE
#SBATCH --mail-user djl35334@uga.edu

module load BLAST+/2.2.31
makeblastdb -in Daucus_carota.GCF_001625215.1.PROTEIN.fix.fa -parse_seqids -dbtype prot
blastp -query ALL_COMBINED_1_MISMATCH_UNIQ_MAP.FILTER.GT3000.bam.MULTI.READ.CORR.TRANSDECODER.PROT.FIX_HEADER.fix.fa -db Daucus_carota.GCF_001625215.1.PROTEIN.fix.fa -evalue 1e-5 -num_threads 10 -outfmt 6 > U.GIBBA_to_Daucus_carota.GCF_001625215.1.PROTEIN.fix.fa.blast
