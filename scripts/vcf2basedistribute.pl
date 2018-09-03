#! /usr/bin/env perl
use strict;
use warnings;
die "Usage:perl $0 <vcf file> <output>\n" unless @ARGV == 2;
my $vcf = $ARGV[0];

if($vcf=~/\.gz$/){
	open(I,"zcat $vcf |") || die "Cannot open $vcf!\n";
}
else{
	open(I,"< $vcf") || die "Cannot open $vcf!\n";
}
open O,">$ARGV[1]" or die $!;

my @samplelist;
my %hash;
my ($ref,$alt);
while(<I>){
	chomp;
	next if($_=~/^##/);
	my @line = split /\s+/,$_;
	$ref = $line[3];
	if($_=~/^#CHR/){
		for(my $i=9;$i<@line;$i++){
			push @samplelist,$line[$i];
		}
	}
	else{
		next if($line[4] eq ".");
		my @type = split /\,/,$line[4];
		for (my $j=9;$j<@line;$j++){
			if($line[$j]=~/1\/1/){
				$alt = $type[0];
			}
			elsif($line[$j]=~/2\/2/){
				$alt = $type[1];
			}
			elsif($line[$j]=~/3\/3/){
				$alt = $type[2];
			}
			else{
				$hash{$line[0]}{$samplelist[$j-9]}{sum}+=0;
				$hash{$line[0]}{$samplelist[$j-9]}{type1}+=0;
				$hash{$line[0]}{$samplelist[$j-9]}{type2}+=0;
				$hash{$line[0]}{$samplelist[$j-9]}{type3}+=0;
				next;
			}
			my($num1,$num2,$num3)=&type($ref,$alt);
			$hash{$line[0]}{$samplelist[$j-9]}{sum}++;
			$hash{$line[0]}{$samplelist[$j-9]}{type1}+=$num1;
			$hash{$line[0]}{$samplelist[$j-9]}{type2}+=$num2;
			$hash{$line[0]}{$samplelist[$j-9]}{type3}+=$num3;
		}
	}
}

close I;

my $header=join "\t",@samplelist;
print O "Seq\t$header\n";
foreach my $key1(sort keys %hash){
	print O "$key1\t";
	for(my $k=0;$k<@samplelist;$k++){
			my $key2=$samplelist[$k];
			print O "$hash{$key1}{$key2}{sum},$hash{$key1}{$key2}{type1},$hash{$key1}{$key2}{type2},$hash{$key1}{$key2}{type3}\t"
	}
	print O "\n";
}

close O;

sub type{
	my $a = shift;
	my $b = shift;
	my ($type1,$type2,$type3);###########$type1:A/T→G/C,$type2:G/C→A/T,$type3:other
	if(($a eq "A")||($a eq "T")){
		$type2=0;
		if(($b eq "C")||($b eq "G")){
			$type1=1;
			$type3=0;
		}
		else{
			$type1=0;
			$type3=1;			
		}
	}
	else{
		$type1=0;
		if(($b eq "A")||($b eq "T")){
			$type2=1;
			$type3=0;
		}
		else{
			$type2=0;
			$type3=1;			
		}
	}
	return ($type1,$type2,$type3);
}