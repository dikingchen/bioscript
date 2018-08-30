#!/bin/sh
##################### GENOME MAPPING #################
file="A
B"
for d in $file;
do
#BWA generate sam file
bwa mem /home/share/index/duckbase.refseq.v3.fasta -t 8 -M \
                /home/share/DATA/microevo/RNAseq/$d'_1_clean.fq.gz' \
                /home/share/DATA/microevo/RNAseq/$d'_2_clean.fq.gz' \
                >$d'.sam'
#Convert sam to bam
samtools view -bS $d'.sam' > $d'.bam'
#Bam file sort
samtools sort -o $d'.sorted.bam' -T $d'.sorted.tmp' -@ 8 -O bam $d'.bam'
#Basic statistic for bam file
samtools flagstat $d'.sorted.bam' >$d'.flagstat.txt'
# REMOVE process files
rm $d'.sam'
rm $d'.bam'
done
./calling-s1.sh
