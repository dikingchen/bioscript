#! /usr/bin/perl -w
use strict;
die "Usage: $0 <gene file> <phased vcf> <output file>\n" if(@ARGV<3);
open I1,"$ARGV[0]" or die $!;
open I2,"$ARGV[1]" or die $!;
open O,">$ARGV[2]" or die $!;
my %hash;

while(<I1>){
	chomp;
	my @line=split /\s+/,$_;
	$hash{$line[0]}{value}+=$line[1];
	$hash{$line[0]}{count}+=1;
}
close I1;
foreach my $key(keys %hash){
	$hash{$line[0]}{value}=$hash{$line[0]}{value}/hash{$line[0]}{count};
}
print O "CHROM\tPOS\tGENEID\tDM\tRho\n";
while(<I2>){
	chomp;
	my @info=split /\s+/,$_;
	next if(!exists $hash{$info[2]}{value});
	print O "@info\t$hash{$info[2]}{value}\n";
}
close I2;
close O;