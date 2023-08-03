#!/bin/bash
#SBATCH -J U.GIBBA_to_Arabidopsis_thaliana.GCF_000001735.4.PROTEIN.fix.fa.blast
#SBATCH -p batch
#SBATCH --ntasks=1
#SBATCH --mem 20gb
#SBATCH -t 05:00:00
#SBATCH --output=U.GIBBA_to_Arabidopsis_thaliana.GCF_000001735.4.PROTEIN.fix.fa.blast.%j.out
#SBATCH -e U.GIBBA_to_Arabidopsis_thaliana.GCF_000001735.4.PROTEIN.fix.fa.blast.%j.err
#SBATCH --mail-type=NONE
#SBATCH --mail-user djl35334@uga.edu

mkdir Arabidopsis_thaliana
cd Arabidopsis_thaliana
cp ../U.GIBBA_to_Arabidopsis_thaliana.GCF_000001735.4.PROTEIN.fix.fa.blast .
cp ../ALL_COMBINED_1_MISMATCH_UNIQ_MAP.FILTER.GT3000.bam.MULTI.READ.CORR.TRANSDECODER.gff3 .
cp ../Arabidopsis_thaliana.GCF_000001735.4.gff .
cp ../Arabadopsis_thaliana.fix.fa .
cp ../Utricularia_gibba_GENOMIC.fix.fa .
cp ../GET_MODEL_AND_CHR.pl .
cp ../FIND_SYNTENIC_PAIRS.pl .
cp ../FILTER_SYNT_PAIRS.pl .
cp ../EXTRACT_SYNT_REGIONS.pl .
cp ../ORIENT_SEQS_FOR_ALN.pl .
cp ../MICROSYNTENY_SUPPORT.pl .
cp ../fixfa.pl .
cp ../PUTATIVE_CRE_LIST.txt .
perl GET_MODEL_AND_CHR.pl U.GIBBA_to_Arabidopsis_thaliana.GCF_000001735.4.PROTEIN.fix.fa.blast ALL_COMBINED_1_MISMATCH_UNIQ_MAP.FILTER.GT3000.bam.MULTI.READ.CORR.TRANSDECODER.gff3 Arabidopsis_thaliana.GCF_000001735.4.gff
perl FIND_SYNTENIC_PAIRS.pl U.GIBBA_to_Arabidopsis_thaliana.GCF_000001735.4.PROTEIN.fix.fa.blast.GFF.ADD.out 5
ls *.PAIRS.out | xargs -n 1 -I {} echo "perl FILTER_SYNT_PAIRS.pl {} 10" > FILTER.sh
sh FILTER.sh
ls *.FILTER.out | xargs -n 1 -I {} echo "sort {} | uniq -u > {}.uniq.out" > UNIQ.sh
sh UNIQ.sh
perl MICROSYNTENY_SUPPORT.pl U.GIBBA_to_Arabidopsis_thaliana.GCF_000001735.4.PROTEIN.fix.fa.blast.GFF.ADD.out.5.PAIRS.out.10.FILTER.out.uniq.out PUTATIVE_CRE_LIST.txt
