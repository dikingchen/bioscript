#! /usr/bin/perl -w
use strict;
die "Usage: $0 <fasta file> <output file> \n" if(@ARGV<2);
open I,"$ARGV[0]" or die $!;
open O,">$ARGV[1]" or die $!;
$/=">";
my %fasta;
my %hash;

my ($species,$seq,$seq_length);
my ($A_num,$C_num,$G_num,$T_num,$X_num)=(0,0,0,0,0);
while(<I>){
	chomp;
	if($_=~/(.*)\n(.*)\n/){
		$species=$1;
		$seq=$2;
	}
	$seq_length=length($seq);
	for(my $i=0;$i<$seq_length;$i++){
		$fasta{$species}{$i}=substr($seq,$i,1);
	}
}
close I;
for(my $i=0;$i<$seq_length;$i++){
	foreach my $key1(keys %fasta){
		my $temp=$fasta{$key1}{$i};
		if($temp=~/[Aa]/){$A_num++;}
		elsif($temp=~/[Cc]/){$C_num++;}
		elsif($temp=~/[Gg]/){$G_num++;}
		elsif($temp=~/[Tt]/){$T_num++;}
		else{$X_num++;}
	}
	my @array=($A_num,$C_num,$G_num,$T_num,$X_num);
	my @temp_array=&rank(\@array);
	($A_num,$C_num,$G_num,$T_num,$X_num)=(0,0,0,0,0);
	if($temp_array[0]>=96){
		foreach my $key1(keys %fasta){
			delete $fasta{$key1}{$i};
		}
	}
	else{next;}
}



foreach my $key1(keys %fasta){
	print O ">$key1\n";
	foreach my $key2(sort {$a<=>$b} keys %{$fasta{$key1}}){
		print O "$fasta{$key1}{$key2}";
	}
	print O "\n";
}

sub rank{
	my $array=shift;
	my @sort_array= sort {$b <=> $a} @{$array};
	return @sort_array;
}