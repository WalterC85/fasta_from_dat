#!/Users/walter/miniconda2/bin/perl

use Array::Utils qw(:all);  ## loading this utility to be albe to compare different arrays

if (!$ARGV[0]){   #reading imput file with list of Name descriptors to look for in the ID line of hte .dat file
print "Please introduce your imput file .dat : \n";
$file=<STDIN>;         #This is in case the input is not in the argument, we demand the name of the file             
chomp $file;
}else{
$file=$ARGV[0]; #When the files are given by arguments (perl program.pl file.fasta list.txt)
chomp $file;
}
($name,$extension)=split(/\./,$file);   #Once we have $file from any of the ways, we remove the extension to create the output only with one extension

$tot_genes = `grep -c "//" < $file`;

open(input,$file);
open(output, ">$name.fasta");

my @gene_not_found;
my @gene_found;
my $seq;

$end_line = '//';
$mark=0;      #I put a mark to know how many lines I went through
$mark1=0;   ## this mark will be used to count how many genes the script managed to extract
print "Your script is running correctly. This will take a while\n";
print "Total numnber of genes to examine is $tot_genes\n";
while (<input>){
  chomp $_;#Remember, always you take information from a file or from the prompt to remove the "Enter"
  if ($_ =~ /^ID/){
    ($ID,$id,@rest)=split(/\s+/,$_);
    #print "$ID\n$id\n";
    }
  if ($_ =~ /^GN/){
    ($GN,$gn_name,@rest)=split(/\s+/,$_);
    $gn_name=~s/;//g;
    #print "$GN\n$name\n";
    }
  if ($_ =~ /^\s/){
    #push @database_subset, $_;
    $seq.=$_;
    }
  if ($_ =~ /^$end_line/){
    $seq=~s/\s+//g;
    $length=length $seq;
    print output ">$id\t$gn_name\t$length"."aa\n$seq\n";
    $seq="";
  }
}  
#my @minus = array_minus( @gene_not_found, @gene_found);
#my @minus_unique =   unique(@minus);
#foreach $m(@minus_unique){
#  print output2 "$m\n";
#}
#print "The script identified $mark1 genes matching with your input list.\nYour script run correctly.\n";
close (input,output);