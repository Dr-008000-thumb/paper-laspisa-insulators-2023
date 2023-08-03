tar -zxvf TransDecoder-TransDecoder-v5.5.0.tar.gz
./TransDecoder-TransDecoder-v5.5.0/util/gtf_genome_to_cdna_fasta.pl ALL_COMBINED_1_MISMATCH_UNIQ_MAP.FILTER.GT3000.bam.MULTI.READ.CORR.gtf U.gibba.fa > U.gibba.transcripts.fasta
./TransDecoder-TransDecoder-v5.5.0/util/gtf_to_alignment_gff3.pl ALL_COMBINED_1_MISMATCH_UNIQ_MAP.FILTER.GT3000.bam.MULTI.READ.CORR.gtf > ALL_COMBINED_1_MISMATCH_UNIQ_MAP.FILTER.GT3000.bam.MULTI.READ.CORR.gff3
./TransDecoder-TransDecoder-v5.5.0/TransDecoder.LongOrfs -t U.gibba.transcripts.fasta
./TransDecoder-TransDecoder-v5.5.0/TransDecoder.Predict -t U.gibba.transcripts.fasta

./TransDecoder-TransDecoder-v5.5.0/util/cdna_alignment_orf_to_genome_orf.pl U.gibba.transcripts.fasta.transdecoder.gff3 ALL_COMBINED_1_MISMATCH_UNIQ_MAP.FILTER.GT3000.bam.MULTI.READ.CORR.gff3 U.gibba.transcripts.fasta > ALL_COMBINED_1_MISMATCH_UNIQ_MAP.FILTER.GT3000.bam.MULTI.READ.CORR.TRANSDECODER.gff3
