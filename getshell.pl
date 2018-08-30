#! /usr/bin/perl -w
use strict;
die "Usage: $0 <gene file> <vcffile> <output file>\n" if(@ARGV<2);
open I,"$ARGV[0]" or die $!;
my $vcffile=$ARGV[1];
open O,">$ARGV[2]" or die $!;
my $count=1;
while(<I>){
	chomp;
	my @line=split /\s+/,$_;
	my $start=$line[0]*1000;
	my $end=$line[1]*1000;
	print O "vcftools --vcf $vcffile --from-bp $start --to-bp $end --ldhat --chr chr3D --phased --out $ARGV[0]\_$count\n";
	$count++;
}
