#pen(ALLRETRO, "allretros.fas") or die;
my %retros;
my $seq="";
my $name="";
while(my $line=<STDIN>){
        chomp $line;
        my @a=split//,$line;
		
        if($a[0] eq ">"){
                if($name ne ""){
                        print "$name\n$seq\n";
			$retros{$name}=$seq;
                }
                $name=$line;
                $seq="";
        }
        else{
                $seq.=$line;
        }

}
$retros{$name}=$seq;
print "$name\n$seq\n";
