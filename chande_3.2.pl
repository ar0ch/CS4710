#!/usr/bin/perl -w
# Aroon Chande
#CS4710 Program 3.2
use strict;
my $filename = join ".",$ARGV[0],"pdb";
open PDB, $filename or die "Could not open $filename: $!"; # Open or die
my @PDB_data = <PDB>; # Read PDB into array
close PDB;
my(%strand1,%strand2,%strand1true,%strand2true);
my $length = scalar(@PDB_data);
foreach my $lines (@PDB_data){
	my @columns=split(/\s+/,$lines);
	if ($columns[0] eq "ATOM" && $columns[4] eq $ARGV[1]){
	if (defined $strand1{$columns[5]}){
			$strand1{$columns[5]} .= $lines;}
	else {
		$strand1{$columns[5]} = $lines;}}
	elsif ($columns[0] eq "ATOM" && $columns[4] eq $ARGV[2]){
		if (defined $strand2{$columns[5]}){
			$strand2{$columns[5]} .= $lines;}
		else {
			$strand2{$columns[5]} = $lines;}
}}
my ($xsum,$x2,$ysum,$y2,$zsum,$z2,$true,$dist) = ('0','','0','','0','','0','0');
my ($xcentroid,$ycentroid,$zcentroid);
for(my $i=1; $i <= keys %strand1; $i++){
	($xsum,$ysum,$zsum) = ('0','0','0');
	my $atomcoords= $strand1{$i};
	my @atomcoords= split(/\n/, $atomcoords);
	$x2 = scalar(@atomcoords);
	foreach (@atomcoords){
		my @atomcoords = split(/\s+/, $_);
		$xsum += $atomcoords[6];
		$ysum += $atomcoords[7];
		$zsum += $atomcoords[8];
		   }
	distance_Centroid($xsum,$ysum,$zsum,$x2); # Calculate distance
	$strand1{$i} = "$xcentroid	$ycentroid	$zcentroid";
}
for(my $i=1; $i <= keys %strand2; $i++){
	($xsum,$ysum,$zsum) = ('0','0','0');
	my $atomcoords= $strand2{$i};
	my @atomcoords= split(/\n/, $atomcoords);
	$x2 = scalar(@atomcoords);
	foreach (@atomcoords){
		my @atomcoords = split(/\s+/, $_);
		$xsum += $atomcoords[6];
		$ysum += $atomcoords[7];
		$zsum += $atomcoords[8];
		distance_Centroid($xsum,$ysum,$zsum,$x2); # Calculate distance
    }
	$strand2{$i} = "$xcentroid	$ycentroid	$zcentroid";
}
my ($x1,$y1,$z1);
foreach (sort { $a <=> $b} keys %strand1){
	my @coords = split(/\t/, $strand1{$_});
	my $strand1atom = $_;
    $x1 = $coords[0];
    $y1 = $coords[1];
    $z1 = $coords[2];
	foreach (sort { $a <=> $b} keys %strand2){
		my @coords2 = split(/\t/, $strand2{$_});
	    $x2 = $coords2[0];
	    $y2 = $coords2[1];
	    $z2 = $coords2[2];
		$dist = distance_Calpha($x1,$x2,$y1,$y2,$z1,$z2);
		if ($dist <= $ARGV[3]){
			$strand1true{$strand1atom} = "True";
			$strand2true{$_} = "True";
			$true="True";
}}}
if ($true eq "True"){
	print "The below are the residues of chain $ARGV[1] whose centroid is below the threshold of $ARGV[3]:\n";
	foreach (sort { $a <=> $b }  keys %strand1true){
		if ($strand1true{$_} eq "True"){
			chomp $_};
			print "$_ ";}
		print "\nThe below are the residues of chain $ARGV[2] whose centroid is below the threshold of $ARGV[3]:\n";
	foreach (sort { $a <=> $b }  keys %strand2true){
		if ($strand2{$_} eq "True"){
			chomp $_};
			print "$_ ";}
	print "\n";}
else {print "No C-alpha atoms are below the threadhold ($ARGV[3])\n"}
###############################################################################
#Subroutines
###############################################################################
sub distance_Centroid{
	my($xsum,$ysum,$zsum,$x2) = @_;
	$xcentroid = $xsum/$x2; 
	$ycentroid = $ysum/$x2;
	$zcentroid = $zsum/$x2;
}
sub distance_Calpha{
	my ($x1,$x2,$y1,$y2,$z1,$z2) = @_;
	$dist = sqrt(((($x2-$x1)**2)+(($y2-$y1)**2)+(($z2-$z1)**2)));
	return $dist;
}