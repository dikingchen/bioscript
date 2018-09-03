#! /usr/bin/perl -w
use strict;
die "Usage: $0 <output file> \n" if(@ARGV<1);
my $dir = $ENV{'PWD'};

my @file = <$dir/*.out>;
my %hash;
my $species_name;
my @species;
foreach my $file(@file){
	open I,"< $file";
	while(<I>){
		chomp;
		if($_ =~/Ref/){
			my @line= split /\s+/,$_;
			$species_name = $line[1];
			push @species,$species_name;
		}
		else{
			my @info = split /\s+/,$_;
			$hash{$info[0]}{$species_name}=$info[1];
		}
	}
}

open O, "> $ARGV[0]" or die $!;
print O "Reference\t";
for(my $i=0;$i<@species;$i++){print O "$species[$i]\t";}
print O "\n";

foreach my $key(keys %hash){
	print O "$key\t";
	for (my $i=0;$i<@species;$i++){
		if(!exists $hash{$key}{$species[$i]}){$hash{$key}{$species[$i]}="NA"};
		print O "$hash{$key}{$species[$i]}\t";
	}
	print O "\n";
}
close O;