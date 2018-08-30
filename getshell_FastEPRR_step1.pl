#!/usr/bin/perl
use strict;

for(my $i=1;$i<=7;$i++){
        open(OUT,">chr$i.sh") || die "Cann't open file!\n";
        print OUT "#!/bin/bash\n\nR --no-save <<EOF\n\nlibrary(FastEPRR)\n\nFastEPRR_VCF_step1(vcfFilePath=\"/home/zkzhou/lm/introgression/recombination/DGenome/chr${i}D.wild.vcf\",idvlConsidered=\"Ae;S27;S28;S29;S30\",winLength=\"20\",stepLength=\"10\",erStart="1",srcOutputFilePath=\"/home/zkzhou/lm/introgression/recombination/DGenome/step1/chr${i}_20Kb_rec\")\n";
        close OUT;
}