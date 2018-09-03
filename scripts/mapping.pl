#! /usr/bin/perl -w
use strict;
for(my $i=0;$i<10;$i++){
	open O,">mapping_$i.sh" or die $!;
	my $a=$i*20+1;
	my $b=($i+1)*20+1;
	print O "#!/bin/bash
	for d in {$a..$b};
	do
	#BWA generate sam file
			bwa mem /home/zhou/dadi/CNV/mapping/base.fa -t 8 -M \
					/home/zhou/dadi/CNV/$d.SD/$d.read1.fq \
					/home/zhou/dadi/CNV/$d.SD/$d.read2.fq \
					>$d.sam
	#Convert sam to bam
	samtools view -bS $d.sam > $d.bam
	#Bam file sort
	samtools sort -o $d.sorted.bam -T $d.sorted.tmp -@ 8 -O bam $d.bam
	done"
}
close O;

