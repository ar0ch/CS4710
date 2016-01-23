#!/usr/bin/perl -w
# Aroon Chande
#CS4710 Program 2.1
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

#my $atomcoords= $rectypes{'ATOM'};
#print $atomcoords

my $atomcoords= $rectypes{'ATOM'};
my @atomcoords= split(/\n/, $atomcoords);
my $count=0;
my $xsum=0;
my $ysum=0;
my $zsum=0;
foreach my $position (@atomcoords){
		my @atomcoords = split(/\s+/, $position);
#		print $atomcoords[6];
		my $x = $atomcoords[6];
        my $y = $atomcoords[7];
        my $z = $atomcoords[8];
        $xsum += $x;
        $ysum += $y;
        $zsum += $z;
	    $count = $count +1;
        }
my $xcentroid = $xsum/$count;
my $ycentroid = $ysum/$count;
my $zcentroid = $zsum/$count;
my $xcentroidr = sprintf("%.3f",$xcentroid);
my $ycentroidr = sprintf("%.3f",$ycentroid);
my $zcentroidr = sprintf("%.3f",$zcentroid);
print "The centroid coordinates are $xcentroidr,$ycentroidr,$zcentroidr\n"