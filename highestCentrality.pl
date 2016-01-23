#!/usr/bin/perl -w
use strict;

###############################################################################################################################################
#				Program to find the node with highest centrality, i.e the most connected node in a graph
# 				User should input a .sif file ; Usage : ./highestCentrality.pl fileName ###############################################################################################################################################							

######################################################## Main Function ####################################################################
sub createAdjacencyMatrix($);
sub allPairsShortestPaths($$);
sub closenessCentrality($);
sub findMaxCentrality($);

my $file = $ARGV[0];


my ($refMatrix,$refHash, $refProt) = createAdjacencyMatrix($file);
my @ADJ = @{$refMatrix};                                      ### Contains the Adjacency Matrix
my %HASH = %{$refHash};																				### A hash mapping the indexes to the protein sequences
my @UniqueProt = @{$refProt};

my $refDist = allPairsShortestPaths(\@ADJ,\%HASH);	
my @shortestDist = @{$refDist};																### Contains the Shortest Distance Matrix
my $refClose = closenessCentrality(\@shortestDist); 
my @closenessCentrality = @{$refClose};												### Contains the Closeness centrality array
my $indexMaxCentrality = findMaxCentrality(\@closenessCentrality);  ### Contains the index of the protein with the maximum centrality


#print " The Adjacency Matrix is : \n";

my $i; my $j;
for($i=0; $i<scalar(@ADJ); $i++)
{
	for($j=0; $j<scalar(@ADJ); $j++)
	{
		print $ADJ[$i][$j]," ";
	}
	print "\n";
}  
print "\n";

print "The Proteins(along with their closeness centrality with the Corresponding Indexes in the Adjacency Matrix are : \n";
print "The Proteins in the adjacency matrix are like : (1,2) index in the matrix would correspond to (protein with index 1,protein at index 2)\n\n";
print "Protein ---> Index ---> Closeness Centrality\n\n";
foreach my $element(@UniqueProt)
{
	print $element,"--> ",$HASH{$element},"--> ",$closenessCentrality[$HASH{$element}],"\n";
}

foreach my $element(@UniqueProt)
{
	if($HASH{$element} == $indexMaxCentrality)
	{
		print "\nThe protein with maximum value of Closeness Centrality is :",$element,"\n";
	}
}
####################################################### End of Main Function ##############################################################

####################################################### Adjacency Matrix Subroutine  ######################################################
sub createAdjacencyMatrix($)
{
	my $f = $_[0];
	until(open(FILE,$f))
	{
		print "Cannot open the file, exiting....\n";
		exit;
	} 
	
	my @contents = <FILE>;
	close(FILE);

	my $line; my @words; my $i=0; my @prot1; my @prot2;
	
	foreach $line(@contents)
	{
		chomp($line);
		@words = split("\t",$line);
		$prot1[$i] = $words[0];
		$prot2[$i] = $words[2];
		$i++;
	}
	
	push(@prot1,@prot2);	
	use List::MoreUtils qw(uniq);
	my @uniqueProt = uniq(@prot1);
  $i=0; my $j; my @A; my $flag = 0; my %hash; 
	my @uniqueProtcopy = @uniqueProt;
	foreach my $seq(@uniqueProt)
	{	
		$j =0; $hash{$seq} = $i;
		foreach my $seq2(@uniqueProtcopy)
		{
			foreach $line(@contents)
			{
				chomp($line);
				@words = split("\t",$line);
				if($seq eq $words[0] && $seq2 eq $words[2])
				{
					$A[$i][$j] = 1;
					$flag = 0;
					last;
				} 	
				else
				{
					$flag = 1;
					$A[$i][$j] = 0;
				}
			}
			$j++;									
		}		
		$i++;	
	}
	my $r = $i; 
	my $c = $j;
	#print "\n","\n";
	for($i = 0; $i<$r; $i++)
	{
		for($j=0; $j<$c; $j++)
		{
			#print $A[$i][$j]," ";
		}
		#print "\n";
	}
	return (\@A,\%hash,\@uniqueProt);
}
########################################################## All pairs shortest path Subroutine #############################################
sub allPairsShortestPaths($$)
{
	my $i; my $j; my $k; 
	@ADJ = @{$_[0]}; %HASH = %{$_[1]};
	
	my @DIST;  
	for($i=0; $i<scalar(@ADJ); $i++)
	{
		for($j=0; $j<scalar(@ADJ); $j++)
		{
			if($ADJ[$i][$j] == 0)
			{
				$DIST[$i][$j] = 99999; 				### 99999 => infinity
			}			
			else
			{
				$DIST[$i][$j] = 1; 
			}
		}
	}

	for($i=0; $i<scalar(@ADJ); $i++)
	{
		for($j=0; $j<scalar(@ADJ); $j++)
		{
			for($k=0; $k<scalar(@ADJ); $k++)
			{
				if($DIST[$i][$k] + $DIST[$k][$j] < $DIST[$i][$j])
				{
					$DIST[$i][$j] = $DIST[$k][$j] + $DIST[$k][$j];
				}
			}
		}
	}

	return \@DIST;		
}
################################################# Closeness Centrality Subroutine #########################################################
sub closenessCentrality($)
{
	my @DIST = @{$_[0]};
	
	my @close; my $i; my $j; my $dist;

	for($i=0; $i<scalar(@DIST); $i++)
	{
		$dist = 0;
		for($j=0; $j<scalar(@DIST); $j++)
		{
			$dist+= $DIST[$i][$j];
		}
		$close[$i] = 1/$dist; 
	}
	
	return \@close;
}

###################################################### Max Closeness Centrality Subroutine ################################################
sub findMaxCentrality($)
{
	@closenessCentrality = @{$_[0]};
	my $max = $closenessCentrality[0]; my $i=0; my $maxIndex;
	for($i=0; $i<scalar(@closenessCentrality); $i++)
	{
		if($closenessCentrality[$i] > $max)
		{	
			$max = $closenessCentrality[$i];
			$maxIndex = $i; 
		}
	}
	return $maxIndex;
}

################################################################ END ######################################################################
