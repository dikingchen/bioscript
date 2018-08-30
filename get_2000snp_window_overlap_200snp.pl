#! /usr/bin/perl -w
use strict;

die "Usage: $0 <part> <site_file>\n" if(@ARGV<2);

my $file_dir = "/stor9000/apps/users/NWSUAF/2016050003/wheat/recombination/DGenome/LDHat/";
my $part = $ARGV[0];
my $result_dir = "$file_dir/$part";
my $site_file = $ARGV[1];
my ($ctrl1,$ctrl2)=1;
my %hash;
open I, "$site_file" or die $!;
while(<I>){
	chomp;
	if($ctrl1<25){$hash{$ctrl2}{$ctrl1}=$_;}
	elsif(($ctrl1>=25)&&($ctrl1<50))
		{
			$hash{$ctrl2}{$ctrl1}=$_;
			$hash{$ctrl2+1}{$ctrl1-25}=$_;
		}
	else{
			$hash{$ctrl2}{$ctrl1}=$_;
			$hash{$ctrl2+1}{$ctrl1-25}=$_;
			$ctrl1-=24;
			$ctrl2+=1;
	}
}
close I;
for(my $i=1;$i<=$ctrl2;$i++){
	open O, ">$part_$i" or die $!;
	for(my $j=0;$j<50;$j++){print O "$hash{$i}{$j}\n";}
	close O;
}
