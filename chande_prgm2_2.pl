#!/usr/bin/perl -w
# Aroon Chande
#CS4710 Program 2.2
use List::Util qw( min max );
use strict;
print "Enter the PDBID of the file you wish to open:  ";
my $pdb='';
my $file=<>;
chomp $file;
my $filename = join ".",$file,"pdb";
open PDB, $filename or die "Could not open $file: $!";
my @PDB_data = <PDB>;
close $pdb;
my %rectypes = (  );

foreach my $line (@PDB_data) {
        my($record) = ($line =~ /^(\S+)/);
        if(defined $rectypes{$record} ) {
                $rectypes{$record} .= $line;
        }else{
                $rectypes{$record} = $line;
        }
}

my $atomcoords= $rectypes{'ATOM'};
my @atomcoords= split(/\n/, $atomcoords);
my $count=0;
my $xsum=0;
my $ysum=0;
my $zsum=0;
my @distance;
foreach my $position (@atomcoords){
		my @coords = split(/\s+/, $position);
		$count = $count +1;
#		print $atomcoords[6];
		my $x2;
		my $y2;
		my $z2;
		my $x1 = $coords[6];
        my $y1 = $coords[7];
        my $z1 = $coords[8];
		foreach my $position2 (@atomcoords){
			my @coords2 = split(/\s+/, $position2);
			$x2 = $coords[6];
	        $y2 = $coords[7];
	        $z2 = $coords[8];
			my $dist= sqrt(((($x2-$x1)**2)+(($y2-$y1)**2)+(($z2-$z1)**2)));
			push (@distance,$dist)
		}	
}
my $max = max @distance;
print $max\n;
