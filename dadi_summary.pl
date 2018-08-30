#! /usr/bin/env perl
use strict;
use warnings;
die "Usage:perl $0 <out directory> <fs>\n" unless @ARGV == 2;
my $result_dir=$ARGV[0];
my $length_file="effective.len";
my $miu=4.32e-9;
my $gen_time=2;
my $out_file="$result_dir.sta";
my $param_file="$result_dir.param";
my $fs=$ARGV[1];

my @files=<$result_dir/*/*>;

my %hash;
foreach my $file(@files){
    open(I,"< $file");
    while(<I>){
        chomp;
        next unless(/DADIOUTPUT/);
        my $param_name=<I>;
        my $param_value=<I>;
        chomp $param_name;
        chomp $param_value;
        next if($param_value=~/--/ || $param_value=~/nan/);
        my @params=split(/\s+/,$param_value);
        $hash{$file}{likelihood}=$params[0];
        $hash{$file}{param_value}=$param_value;
        $hash{$file}{param_name}=$param_name;
    }
    close I;
}

open(I,"< $length_file");
my $length=<I>;
chomp $length;
print "$length\n";
close I;

open S,">> $out_file" or die "Cannot modify $out_file\n";
print S "### new result ###\n";
my $time=`date`;
chomp $time;
print S "$time\n";
open L,">>$param_file" or die "Cannot create $param_file\n";
my $control=0;
foreach my $file(sort {$hash{$b}{likelihood} <=> $hash{$a}{likelihood}} keys %hash){
    my $param_name=$hash{$file}{param_name};
    my $param_value=$hash{$file}{param_value};
    my @names=split(/\s+/,$param_name);
    my @params=split(/\s+/,$param_value);
    my @head;
    my @content;
    if($control==0){
	print "$file\n";
	print S "$file\n";
	print "$param_name\n$param_value\n";
	print S "$param_name\n$param_value\n";
    }
    push @head,"file_name";
    push @content,$file;

    push @head,"likelihood";
    push @content,$params[0];

    my $theta=$params[1]/$length;
    if($control==0){
	print "theta:\t$theta\n";
	print S "theta:\t$theta\n";
    }
    push @head,"theta";
    push @content,$theta;
    my $nref=$theta/(4*$miu);
    if($control==0){
	print "Nref:\t$nref\n";
	print S "Nref:\t$nref\n";
    }
    push @head,"Nref";
    push @content,$nref;

    for(my $i=2;$i<@names;$i++){
        $names[$i]=~/^(\w)\./;
        my $type=$1;
        # print "$type\n";
        my $param=$params[$i];
        if($type eq "N"){
            $param = $param * $nref;
        }
        elsif($type eq "T"){
            $param = 2 * $nref * $param * $gen_time;
        }
        elsif($type eq "M"){
            # $param = 2 * $nref * $param;
            $param = $param / (2 * $nref);
        }
	if($control==0){
	    print "$type\t$names[$i]\t$param\n";
	    print S "$type\t$names[$i]\t$param\n";
	    &plot(@params);
	}
	push @head,$names[$i];
	push @content,$param;
    }
    if($control == 0){
	print L join "\t",@head,"\n";
    }
    print L join "\t",@content,"\n";
    $control++;
    # last;
}
close S;
close L;

sub plot{
    my @params=@_;
    shift @params;
    shift @params;
    my $params=join ",",@params;
    open(O,"> 04.plot_first_optimizations.py");
    print O "
#! /usr/bin/env python2
import matplotlib
matplotlib.use('Agg')
import numpy
import sys
from numpy import array
import pylab
import dadi
from dadi import *
data = dadi.Spectrum.from_file(\"$fs\")
ns = data.sample_sizes
pts_l = [40,50,60]
def  split_bottle_mig((T1,T2,T3,nu1A,nu1B,nu1F,nu2A,nu2F), (n1,n2), pts):
    xx = yy = dadi.Numerics.default_grid(pts)
    phi = dadi.PhiManip.phi_1D(xx)
    phi = dadi.PhiManip.phi_1D_to_2D(xx, phi)
    phi = dadi.Integration.two_pops(phi, xx,T1,nu1=nu1A,nu2=nu2A,m12=0, m21=0)
    phi = dadi.Integration.two_pops(phi, xx,T2,nu1=nu1B,nu2=nu2A,m12=0, m21=0)
    phi = dadi.Integration.two_pops(phi, xx,T3,nu1=nu1F,nu2=nu2F,m12=0, m21=0)
    sfs = dadi.Spectrum.from_phi(phi, (n1,n2), (xx,yy))
    return sfs

func =split_bottle_mig
p0 = [ $params ]
func_ex = dadi.Numerics.make_extrap_log_func(func)
model = func_ex(p0, ns, pts_l)

pylab.figure()
dadi.Plotting.plot_2d_comp_multinom(model, data, vmin=1, resid_range=50,pop_ids =('AFR','CNS'))
pylab.show()
pylab.savefig('AFR_CNS.png', format='pdf',dpi=500)

";
    close O;
}
