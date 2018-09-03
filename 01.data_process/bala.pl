#! /usr/bin/perl -w
use strict;
open I,"$ARGV[0]";
my $sum=0;
while(<I>){
	chomp;
	next if($_=~/^Loci/);
	my @line=split /\s+/,$_;
	next if($line[1]==0);
	$sum+=$line[2];
}
$avrg=$sum/49;
print "$avrg\n";