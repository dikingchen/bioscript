#! /usr/bin/perl -w
use strict;
die "Usage: $0 <gff file> <output file>\n" if(@ARGV<2);
open I,"$ARGV[0]" or die $!;
$/=">";
my %seq;
while(<I>){
	chomp;
	if($_=~/(NP.*)(.\d)\s+(.*])\n([A-Z]+>)/){
		if(!exists $seq{$1}{pep}){
			$seq{$1}{pep}=$4;
		}
		elsif(length($4)>length($seq{$1}{pep})){
			$seq{$1}{pep}=$4;
		}
		else(next;)
	}
}
close I;
open O,">$ARGV[1]" or die $!;
foreach my $key(sort keys %seq){
	print O ">$key\n$seq{$key}";
}

=head
>NP_001273664.1 gonadotropin-releasing hormone receptor-like [Latimeria chalumnae]
MENNFKNGTQGKNCCAITNNSLPALKNYTDLPTLTISGKIRVIATMFLFLTSCILNVSFLIKVYRWEKKNKSSRMKVLLK
HLMLANLLETVIVMPLDGVWNITVQWYAGEFLCKVLNFLKLFSMYAPAFMVVVISLDRCLAITRPFSVKNNNKFGKYNIH
LAWTISLILAGPQIFVFGVIDERYRADSDSMEIFFQCVTHKSFTEWWQQTFYNLFTFGCIFVTPLLIMLVCNFKIIFTMT
QVLRQDPSKMDLKRSKNNIPQARLKTLKMTIAFATSFIICWAPYYVLGIWYWFEPEILRWVSDPVYHFFCLFGLLNPCFD
PLIYGYFSL
>NP_001273665.1 gonadotropin-releasing hormone II receptor-like [Latimeria chalumnae]
MFPSAMNHSLSETVNPVLLTQPLMCEVNSTCELNLATVSPNASASNFNLPVFSSAAKARVIITFVLCAVSTFCNVAVLWV
ASTGRKRKSHVRVLILNLTAADLLVTFIVMPLDATWNITVQWQGGDVACRVLMFLKLMAMYSCAFVTVVISVDRHSAILN
PLAINEAKKKNKIMLTVAWIMSILLSVPQIFLFHTVTITIPQNFTQCTTRGSFRKHWQETIYNMFTFVCLFLLPLFIMVF
=cut