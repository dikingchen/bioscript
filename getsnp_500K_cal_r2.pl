#! /usr/bin/perl -w
use strict;
die "Usage: $0 <snplist file> <start_pos>\n" if(@ARGV<2);

my @list;

open I,"$ARGV[0]" or die $!;
open O,">poslist" or die $!;
my $start_pos=$ARGV[1];
push @list,$start_pos;

while(<I>){
	chomp;
	my @info=split /\s+/,$_;
	next if($info[1]<$start_pos+500000);
	if(($info[1]>=$start_pos+500000)&&($info[1]<$start_pos+1000000)){
			push @list,$info[1];
			$start_pos=$info[1];
	}
	else {$start_pos=$info[1];}
}
close I;
for(my $i=0;$i<@list-1;$i++){
	print O "1:$list[$i]\t1:$list[$i+1]\n";
}
close O;
