#! /usr/bin/perl -w
use strict;
die "Usage: $0 <gff file> <annotation file> <output file>\n" if(@ARGV<3);
open I1,"$ARGV[0]" or die $!;
open I2,"$ARGV[1]" or die $!;
open O,"> $ARGV[2]" or die $!;
my %hash;
my %element;
while(<I1>){
	chomp;
	my @line=split /\s+/,$_;
	$hash{$line[0]}{$line[1]}{end}=$line[2];
	$hash{$line[0]}{$line[1]}{gene}=$line[3];
}
close I1;
while(<I2>){
	chomp;
	my $element = $_;
	my @info=split /\:/,$_;
	my $chr=$info[0];
	my @bala=split /\-/,$info[1];
	my $start = $bala[0];
	my $end = $bala[1];
	foreach my $key(keys %{$hash{$chr}}){
		if(($start>=$key)&&($start<=$hash{$chr}{$key}{end})){
			$element{$element}.="$hash{$chr}{$key}{gene};";
			next;
		}
		elsif(($end>=$key)&&($end<=$hash{$chr}{$key}{end})){
			$element{$element}.="$hash{$chr}{$key}{gene};";
			next;
		}
		elsif(($start<=$key)&&($end>=$hash{$chr}{$key}{end})){
			$element{$element}.="$hash{$chr}{$key}{gene};";
			next;
		}
		else {next;}
	}
}
close I2;
foreach my $key1(keys %element){
	print O "$key1\t$element{$key1}\n";
}
close O;