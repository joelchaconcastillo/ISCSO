#Con este script se genera la lista de ejecuciones....
#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
my $file = "ExecutionFileDiversity";
my $fout;
open($fout, '>' ,$file);
my $Instance=0;
my $Sed=0;
my $PATH=  `cd ..; pwd`;
chomp $PATH;
my $Path = "/home/joel.chacon/ISCSO/ISCSO_2021/Iterated_Local_Search/";
my $seed=1;
for(my $seed=1; $seed <=100; $seed=$seed+2){
  for( my $k=4; $k<=4; $k = $k+2){
     print $fout "~\"/home/joel.chacon/MATLAB_2016_Portable/bin/matlab -nojvm -nodisplay -nodesktop -r \\\"cd('".$PATH."');  ILS(".$k.",'".$PATH."/history/NeighboutSize_".$k."_Seed_".$seed."', ".$seed."); exit \\\"\"\n";
  }
}
