#!/usr/bin/perl

use strict;
use warnings;

# Specify the path to your GTF file
my $gtf_file = "ALL_COMBINED_1_MISMATCH_UNIQ_MAP.FILTER.GT3000.bam.MULTI.READ.CORR.TRANSCRIPTS.NO_UNORI.gtf";

# Open the GTF file
open(my $fh, '<', $gtf_file) or die "Could not open file '$gtf_file': $!";

my %gene_transcripts;

# Read through each line of the GTF file
while (my $line = <$fh>) {
    chomp($line);

    # Skip comment lines
    next if ($line =~ /^#/);

    # Split the line into fields
    my @fields = split("\t", $line);

    # Get the gene ID from the 9th field
    my ($gene_id) = $fields[8] =~ /gene_id "([^"]+)"/;

    # Get the transcript ID from the 9th field
    my ($transcript_id) = $fields[8] =~ /transcript_id "([^"]+)"/;

    # Get the FPKM value from the 9th field
    my ($fpkm) = $fields[8] =~ /FPKM "([^"]+)"/;

    # Get the transcript length (end - start + 1)
    my $transcript_length = $fields[4] - $fields[3] + 1;

    # Check if the gene ID already exists in the hash
    if (exists $gene_transcripts{$gene_id}) {
        # If the current transcript is longer, update the length, ID, and line in the hash
        if ($transcript_length > $gene_transcripts{$gene_id}{'length'}) {
            $gene_transcripts{$gene_id}{'length'} = $transcript_length;
            $gene_transcripts{$gene_id}{'transcript_id'} = $transcript_id;
            $gene_transcripts{$gene_id}{'line'} = $line;
        }
        # Add FPKM value to the array for mean calculation
        push @{$gene_transcripts{$gene_id}{'fpkm_values'}}, $fpkm;
    } else {
        # Add the gene, transcript, and line to the hash
        $gene_transcripts{$gene_id}{'length'} = $transcript_length;
        $gene_transcripts{$gene_id}{'transcript_id'} = $transcript_id;
        $gene_transcripts{$gene_id}{'line'} = $line;
        # Add FPKM value to the array for mean calculation
        $gene_transcripts{$gene_id}{'fpkm_values'} = [$fpkm];
    }
}

# Close the GTF file
close($fh);

# Print the whole line containing the longest transcript ID and mean FPKM value for each gene ID
foreach my $gene_id (keys %gene_transcripts) {
    my $line = $gene_transcripts{$gene_id}{'line'};
    my $mean_fpkm = calculate_mean(@{$gene_transcripts{$gene_id}{'fpkm_values'}});
    $line .= "\t$mean_fpkm";
    print "$line\n";
}

# Calculate the mean of an array of values
sub calculate_mean {
    my @values = @_;
    my $sum = 0;
    foreach my $value (@values) {
        $sum += $value;
    }
    my $mean = $sum / scalar(@values);
    return $mean;
}