#!/usr/bin/perl -w
# Aroon Chande
#CS4710 Program 1.2
print "Enter the PDBID of the file you wish to open:  ";
my $pdb='';
my $file=<>;
chomp $file;
$filename = join ".",$file,"pdb";
open PDB, $filename or die "Could not open $file: $!";
my @PDB_data = <PDB>;
close $pdb;
my $seqres='';
my @HELIX=();
my @SHEET= ();
my $red='';
foreach my $line (@PDB_data){
        if($line =~ /^HELIX/)
        {
		$line=split;
        my $start = ($red=$line[6]);
        my $end = $line[9];
        $line = join "  ", $start, $end;
        push @HELIX, $line;
        }
                if($line =~ /^SHEET/)
        {
        my $start = substr($line, 23, 3);
                # $start = substr($;
        my $end = substr($line,34,3);
        # $seqres = join "", $seqres, $line;
                $line = join "  ", $start, $end;
                push @SHEET, $line;
        }

}
foreach $line (@HELIX){
        print "HELIX $line\n";
}
foreach $line (@SHEET){
        print "SHEET $line\n";
}
my $helix = scalar @HELIX;
my $sheet = scalar @SHEET;
print "Number of helices: $helix\n";
print "Number of sheets $sheet\n";
