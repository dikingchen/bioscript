#! /usr/bin/perl -w
use strict;
die "Usage: $0 <maf file> <output file>\n" if(@ARGV<2);
open I,"$ARGV[0]" or die $!;
my %ref_hash;
my %query_hash;
my $ref;
my $ele;
my $ref_seq;
my $query;
my $query_seq;
my @samplelist;
my $judge_param=0;
$/="a score";
while(<I>){
	chomp;
	my @maf=split /\n/,$_;
	next if($maf[1]!~/Platypus/);
	my @ref=split /\s+/,$maf[1];
	$ele=$ref[1];
	$ref_seq=$ref[-1];
	my @temp=split //,$ref_seq;
	for(my $i=0;$i<@temp;$i++){
		$ref_hash{$ele}{$i}=$temp[$i];
	}
	for(my $j=2;$j<@maf;$j++){
		next if($maf[$j]!~/^s/);
		my @temp=split /\s+/,$maf[$j];
		my @query=split /\./,$temp[1];
		$query=$query[0];
		foreach my $k(@samplelist){
			if($k eq $query){$judge_param=1;next;}
			else {next;}
		}
		if($judge_param==0){push @samplelist,$query;}
		else{$judge_param=0;}
		my @temp_seq=split //,$temp[6];
		my ($sum,$type1,$type2,$other)=(0,0,0,0);
		for(my $j=0;$j<@temp_seq;$j++){
#			next if((!exists $ref_hash{$ele}{$j})||(!exists $temp_seq[$j]));
			my ($num1,$num2,$num3)=&type($ref_hash{$ele}{$j},$temp_seq[$j]);
			my $temp=$num1+$num2+$num3;
			if($temp==0){next;}
			else{
				$sum+=1;
				$type1+=$num1;
				$type2+=$num2;
				$other+=$num3;
			}
		}
		$query_hash{$ele}{$query}{sum}+=$sum;
		$query_hash{$ele}{$query}{type1}+=$type1;
		$query_hash{$ele}{$query}{type2}+=$type2;
		$query_hash{$ele}{$query}{other}+=$other;
			
	}
}

close I;
open O,"> $ARGV[1]" or die $!;
my $header=join "\t",@samplelist;
print O "Seq\t$header\n";
foreach my $key1(sort keys %query_hash){
	print O "$key1\t";
	my $length;
	if($key1=~/(.*)\:(\d+)\-(\d+)/){$length=$3-$2;}
	for(my $k=0;$k<@samplelist;$k++){
			my $key2=$samplelist[$k];
			if(!exists $query_hash{$key1}{$key2}{sum}){print O "NA\t";}
			else{
				my $value=($query_hash{$key1}{$key2}{type1}-$query_hash{$key1}{$key2}{type2})/$length*$query_hash{$key1}{$key2}{sum};
				$value=sprintf "%.2f",$value;
				print O "$value\t";
			}
	}
	print O "\n";
}

close O;
sub type{
	my $a = shift;
	my $b = shift;
	my ($type1,$type2,$type3);###########$type1:A/T→G/C,$type2:G/C→A/T,$type3:other
	if(($b=~/$a/i)||($b eq "-")||($a eq "-")){
		$type1=0;
		$type2=0;
		$type3=0;
	}
	elsif($a=~/[ATat]/){
		$type2=0;
		if($b=~/[CGcg]/){
			$type1=1;
			$type3=0;
		}
		else{
			$type1=0;
			$type3=1;			
		}
	}
	elsif($a=~/[CGcg]/){
		$type1=0;
		if($b=~/[ATat]/){
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



