#! /usr/bin/perl -w
use strict;
die "Usage: $0 <gene file> <phased vcf> <output file>\n" if(@ARGV<3);
open I1,"$ARGV[0]" or die $!;
open I2,"$ARGV[1]" or die $!;
open O,">$ARGV[2]" or die $!;

my %hash;
my $ctrl=1;
my $count=1;
while(<I1>){
	chomp;
	my @line=split /\s+/,$_;
	$hash{$ctrl}{start}=$line[1];
	$hash{$ctrl}{end}=$line[2];
	$hash{$ctrl}{genename}=$line[3];
	$ctrl++;
}
close I1;

while(<I2>){
	chomp;
	if($_=~/^\#/){print O "$_\n";}
	else{
		my @info=split /\s+/,$_;
		next if($info[1]<$hash{$count}{start});
		if(($info[1]>$hash{$count}{start})&&($info[1]<$hash{$count}{end})){print O "$_\t$hash{$count}{genename}\n";}
		else{$count++;next;}
	}
	if($count>$ctrl){last;}
}
close I2;
close O;