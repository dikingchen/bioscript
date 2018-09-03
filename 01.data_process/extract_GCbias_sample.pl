#! /usr/bin/perl -w
use strict;
die "Usage: $0 <result table> <output file> \n" if(@ARGV<2);
open I,"$ARGV[0]" or die $!;
open O,">$ARGV[1]" or die $!;
my %taxon;
my %element;
my $length;
while(<I>){
	chomp;
	my @info= split /\s+/,$_;
	$length=@info;
	if($_=~/Seq/){
		print O "Seq\t";
		for(my $i=1;$i<$length;$i++){
			if($info[$i]=~/([^\_]*)\_(.*)/){
				$taxon{$i}{family}=$1;
				$taxon{$i}{species}=$2;
				print O "$info[$i]\t";
			}
		}
		print O "\n";
	}
	else{
		for(my $i=1;$i<@info;$i++){
			$info[$i]=~s/NA/0/;
			$element{$info[0]}{$taxon{$i}{species}}=$info[$i];
		}
	}
}
close I;
foreach my $key1(keys %element){
	my @temp_array;
	for(my $i=1;$i<$length;$i++){
		push @temp_array,$element{$key1}{$taxon{$i}{species}};
	}
	my $temp=&rank(\@temp_array);
	if($temp==1){
		print O "$key1\t";
		print O join "\t",@temp_array;
		print O "\n";
	}
	else {next;}
}


sub rank{
	my $array = shift;
	my $num=0;
	my @sort_array= sort {$b <=> $a} @{$array};
	if($sort_array[0  ]<10){return $num;next;}
	for (my $i=0;$i<$length/2;$i++){
		if((($sort_array[$i]/2)>$sort_array[$i+1])&&($sort_array[$i+1]<3)){
			$num=1;
			next;
		}
		elsif($sort_array[$i]<4){next;}
	}
	return $num;
}