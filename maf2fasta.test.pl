#! /usr/bin/perl -w
use strict;
die "Usage: $0 <sample list> <result maf> \n" if(@ARGV<2);
open I1,"$ARGV[0]" or die $!;
open I2,"$ARGV[1]" or die $!;
my @sample;
my %sample_list;
my %info;
my $length;

while(<I1>){
	chomp;
	push @sample,$_;
}
close I1;
$/="a score";
while(<I2>){
	chomp;
	next if($_=~/^#/);
	my @maf=split /\n/,$_;
	next if(scalar(@maf)<92);
	for(my $i=0;$i<@maf;$i++){
		next if($maf[$i]!~/^s/);
		my @temp= split /\s+/,$maf[$i];
		my $seq= $temp[-1];
		my $name;
		if($temp[1]=~/([^\.]*)\.(.*)/){$name=$1;}
		my @seq=split //,$seq;
		$length=@seq;
		for(my $i=0;$i<$length;$i++){
			$sample_list{$name}{$i}=$seq[$i];
		}
	}
	for(my $i=0;$i<@sample;$i++){
		for(my $j=0;$j<$length;$j++){
			if(!exists $sample_list{$sample[$i]}{$j}){$info{$sample[$i]}{seq}.="_";}
			else{$info{$sample[$i]}{seq}.=$sample_list{$sample[$i]}{$j};}
		}
	}
	%sample_list=();
}
close I2;
foreach my $key(keys %info){
	open O,">$key.output" or die $!;
	print O ">$key\n";
	print O "$info{$key}{seq}\n";
}
close O;