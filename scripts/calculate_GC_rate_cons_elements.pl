#! /usr/bin/perl -w
use strict;
die "Usage: $0 <fasta file> \n" if(@ARGV<1);
open I,"$ARGV[0]" or die $!;
my $dir = $ENV{'PWD'};
my %hash;
my $seq;
my $GC_rate;
my $ref_name;
my $query_name;
while(<I>){
	chomp;
	if($_=~/\>(.*)\|(.*)/){
		$query_name=$1;
		$ref_name=$2;
	}
	$seq=<I>;
	my @seq=split //,$seq;
	my $base=0;
	my $GCbase=0;
	for(my $i=0;$i<@seq;$i++){
		$base++;
		if($seq[$i]=~/[GCgc]/){$GCbase++;}
		else{next;}
	}
	$GC_rate=$GCbase/$base;
	$GC_rate=sprintf "%.2f",$GC_rate;
	$hash{$ref_name}=$GC_rate;
}
close I;
my $species;
if($ARGV[0]=~/ano_refID_fa\/(.*).addID/){
	$species=$1;
}
print "$dir/$species.out";
open O,"> $dir/$species.out" or die $!;
print O "Reference\t$species\n";
foreach my $key(sort keys %hash){
	print O "$key\t$hash{$key}\n";
}
close O;
