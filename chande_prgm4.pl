#!/usr/bin/perl -w
# Aroon Chande
#CS4710 Program 4
use strict;
use utf8;
use List::MoreUtils qw(uniq first_index);
use List::Util qw( min max );
binmode STDOUT, ":utf8";
open SIF, $ARGV[0] or die "Could not open $ARGV[0]: $!"; # Open or die
my @sif_data = <SIF>; # Read sif into array
close SIF;
my %proteins;
my (@node1,@node2,@Adj);
my ($i,$j,$k)=('0','0','0');
#Build ourselves a matrix
foreach (@sif_data){
	chomp $_;
	$_ =~ s/kshv_//g; # remove "kshv_" to make tables prettier
	my @columns = split(/\s+/,$_);
	$node1[$i] = $columns[0];
	$node2[$i] = $columns[2];
	$i++;
}
push(@node1,@node2);	
my @nodes = uniq(@node1);
($i,$j,$k)=('0','0','0'); 
foreach my $row(@nodes){	
	$j=0; 
	$proteins{$i} = $row;
	foreach my $col(@nodes){
		foreach (@sif_data){
			chomp $_;
			my @columns = split(/\s+/,$_);
			if(($row eq $columns[0] || $row eq $columns[2]) && ($col eq $columns[2] || $col eq $columns[0])){
				$Adj[$i][$j] = 1;
				$Adj[$j][$i] = 1;
				last;}	
			else{
				$Adj[$i][$j] = 0;}
		}	$j++;									
	}	$i++;	
}
print "The adjacency matrix represented by $ARGV[0]:\n\t";
for(my $row = 0; $row<$i; $row++){
	print $proteins{$row},"\t";}
print "\n";
for(my $row = 0; $row<$i; $row++){
	print $proteins{$row},"\t";
	for(my $col=0; $col<$j; $col++){
		if ($row == $col){print chr(0x25A0),"\t";}
		else{print $Adj[$row][$col],"\t";}
	}
	print "\n";
}
# Initialize A0 of distance matrix
my @distance;
for($i=0; $i < @Adj; $i++){
	for($j=0; $j < @Adj; $j++){
		if ($Adj[$i][$j] == 0){
			$distance[$i][$j] = 1000;
		}
		else{
			$distance[$i][$j] = 1;}	}	}
# All pairs shortest path
for($i=0; $i < @Adj; $i++){
	for($j=0; $j < @Adj; $j++){
		for($k=0; $k < @Adj; $k++){
			unless ($distance[$i][$k] == 1000 || $distance[$k][$j] == 1000){
			if($distance[$i][$k]+$distance[$k][$j] < $distance[$i][$j]){
				$distance[$i][$j] = $distance[$i][$k]+$distance[$k][$j];}	}	}	}
}
print "The distance matrix represented by $ARGV[0]:\n\t";
for(my $row = 0; $row < @distance; $row++){
	print $proteins{$row},"\t";}
print "\n";	
for(my $row = 0; $row < @distance; $row++){
	print $proteins{$row},"\t";
	for(my $col=0; $col < @distance; $col++){
		if ($row == $col){print chr(0x25A0),"\t";}
		elsif ($distance[$row][$col] == 1000){print chr(0x221e),"\t";}
		else{print $distance[$row][$col],"\t";}
	}
	print "\n";
}
# Closenes of centrality
my (@close,@closeness);
for ($i =0; $i < @distance; $i++){
	my $distsum = 0;
	for($j=0; $j < @distance; $j++){
		$distsum += $distance[$i][$j];
	}
	$close[$i]= $distsum;
	if ($distsum > 0){
	$closeness[$i]= 1/$distsum;}
}
my $center = min(@close);
my ($centerindex) = first_index{ $_ == $center} @close;
print "Node with best closeness of centrality: ","kshv_",$proteins{$centerindex},"\n";

