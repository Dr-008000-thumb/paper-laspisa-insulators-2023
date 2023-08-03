open(COV, $ARGV[0]) || die "Error: $!\n";
open(OUT, ">$ARGV[0].stat");

use Statistics::Descriptive;

my @coverage_data;
my $min = 0;
my $max = 0;
my $median = 0;
my $mean = 0;
my $variance = 0;
my $std_dev = 0;


while ($line = <COV>){
	chomp $line;
	my @parsed = split ("\t", $line);
	push (@coverage_data, $parsed[2]);
}



my $stat_data = Statistics::Descriptive::Full->new();#generates a new stat object inheriting all Statistics::Descriptive methods

$stat_data->add_data(@coverage_data);#assigns the coverage data for each nucleotide position to the object

$min = $stat_data->min();
$max = $stat_data->max();
$median = $stat_data->median();
$mean = $stat_data->mean();
$variance = $stat_data->variance();
$std_dev = $stat_data->standard_deviation();

print OUT "$ARGV[0]\t$min\t$max\t$median\t$mean\t$variance\t$std_dev\n";
