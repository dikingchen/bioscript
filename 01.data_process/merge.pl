#! /usr/bin/perl -w
use strict;
die "Usage: $0 <output file> \n" if(@ARGV<1);
open O,">$ARGV[0]" or die $!;
my %hash;
for(my $i=0;$i<3;$i++){
	open I,"all.fasta.${i}.filter" or die $!;
	while(<I>){
		chomp;
		my $id;
		my $seq;
		if($_=~/>(.*)/){
			$id=$1;
			$seq=<I>;
			$seq=~s/\n//;
			$hash{$id}{seq}.=$seq;
		}
	}
	close I;
}
foreach my $key(keys %hash){
	print O ">$key\n$hash{$key}{seq}\n";
}
close O;