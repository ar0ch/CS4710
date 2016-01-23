#!/usr/bin/perl -w
# Aroon Chande
#CS4710 Program 1.1
# Extract and print primary AA sequence from a user provided PDB
print "Enter the PDBID of the file you wish to open:  ";
my $pdb='';
my $file=<>;
chomp $file;
$filename = join ".",$file,pdb;
open PDB, $filename or die "Could not open $file: $!";
my @PDB_data = <PDB>;
close $pdb;
#chomp(@PDB_data);
my $seqres='';
my $tempseq='';
#my $protlength='';
@length= ();
foreach my $line (@PDB_data){
        if($line =~ /SEQRES/)
        {
        $line =~ s/^.{18}//g;
        $line =~ s/\s*$//g;
        chomp $line;
        $seqres = join "", $seqres, $line;
        }
        elsif($line =~ /DBREF/){
        $line =~ s/^.{60}//g;
        push @length, $line;
        }

}
print "The sequence from $file.pdb:   \n";
print $seqres;
print "\n\n";
print "There are chains of the below length in $filename:\n ";
foreach $line (@length){
        print "$line";
}
