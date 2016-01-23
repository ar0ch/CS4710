#!/usr/bin/perl -w
# Aroon Chande
#CS4710 Program 3.1
use strict;
my $filename = join ".",$ARGV[0],"pdb";
open PDB, $filename or die "Could not open $filename: $!"; # Open or die
my @PDB_data = <PDB>; # Read PDB into array
close PDB;
my(%strand1,%strand2,%strand1true,%strand2true);
foreach (@PDB_data){
	my @columns=split(/\s+/,$_);
	if ($columns[0] eq "ATOM" && $columns[2] eq "CA"  && $columns[4] eq $ARGV[1]){
		$strand1{$columns[5]} = $_;
	}
	elsif ($columns[0] eq "ATOM" && $columns[2] eq "CA"  && $columns[4] eq $ARGV[2]){
		$strand2{$columns[5]} = $_;
	}
}
my ($x1,$x2,$y1,$y2,$z1,$z2,$true,$dist) = ('','','','','','','0','');
foreach (keys %strand1){
	my @coords = split(/\s+/, $strand1{$_});
	my $strand1atom = $_;
    $x1 = $coords[6];
    $y1 = $coords[7];
    $z1 = $coords[8];
	foreach (keys %strand2){
		my @coords2 = split(/\s+/, $strand2{$_});
	    $x2 = $coords2[6];
	    $y2 = $coords2[7];
	    $z2 = $coords2[8];
		$dist = distance_Calpha($x1,$x2,$y1,$y2,$z1,$z2);
		if ($dist <= $ARGV[3]){
			$strand1true{$strand1atom} = "True";
			$strand2true{$_} = "True";
			$true="True";
		}
	}
}
if ($true eq "True"){
	print "The below C-alpha atoms of chain $ARGV[1] are below the threshold of $ARGV[3]:\n";
	foreach (sort { $a <=> $b }  keys %strand1true){
		if ($strand1true{$_} eq "True"){
			chomp $_};
			print "$_ ";
		}
		print "\nThe below C-alpha atoms of chain $ARGV[2] are below the threshold of $ARGV[3]:\n";
	foreach (sort { $a <=> $b }  keys %strand2true){
		if ($strand2{$_} eq "True"){
			chomp $_};
			print "$_ ";
		}
	print "\n";
}
else {print "No C-alpha atoms are below the threadhold ($ARGV[3])\n"}
###############################################################################
#Subroutines
###############################################################################
sub distance_Calpha{
	my ($x1,$x2,$y1,$y2,$z1,$z2) = @_;
	$dist = sqrt(((($x2-$x1)**2)+(($y2-$y1)**2)+(($z2-$z1)**2)));
	return $dist;
}