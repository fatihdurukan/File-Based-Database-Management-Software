#!/usr/bin/perl
#STUDENT NAME: FATIH DURUKAN
#NUMBER:1306161395
#Scripting Languages ( ÖRGÜN) Project 1
#FİNİSH DATE: 05.12.2016 17:00

use DB_File;
use Fcntl;
use warnings;
use strict;

#For deleting directory even if it has subdirectory
use File::Path 'rmtree';

my $sorgu;
my $dbname;
my $dbadress;
my $tablename;
my $newtablename;
my @columns;

#getting current directory
use Cwd;
my $dir = getcwd;

#first argument from command line
$sorgu=$ARGV[0];


#Creating Database which is directory
if ($sorgu eq "Create_DB"){

  my $dataPath = $ARGV[1];
  my $dataName = $ARGV[2];

   chdir $dataPath;
   mkdir $dataName;
   chdir $dir;
   print "Database was created! \n" ;
   #creating text in which contains db name and its location
   open(FILE, ">>DatabaseLocations".'.txt');
   print FILE "Database name: $dataName, Database location: $dataPath\n";
   close(FILE);

}
elsif($sorgu eq "Delete_DB"){
  my $dataPath = $ARGV[1];
  #delete directory where path is.
  rmtree([ "$dataPath" ]);
  print "Database was deleted! \n" ;
}

elsif ($sorgu eq "Delete_Table"){
  my $dataPath = $ARGV[1];
  my $dataName = $ARGV[2];
  #deleting text file which indicates a table
  unlink("$dataPath"."/"."$dataName".'.txt');
  print "Table was deleted! \n" ;

}


elsif ($sorgu eq "Create_Table"){
  #assigning command line argument to values
  my $dataPath = $ARGV[1];
  my $dataName = $ARGV[2];
  my $tableName=$ARGV[3];
  @columns=splice(@ARGV,4);

  my $newtable="";
#creating table name and its columns
  foreach my $line(@columns){
    $newtable =$line.'|'.$newtable;
    }
  $newtable='#'.$tableName."\n".$newtable;
  print "Table name and columns are ready!\n" ;


  open(FILE, "> $dataPath"."/"."$dataName".'.txt');
  print FILE $newtable;
  close(FILE);
  print "Table name and columns was written in table!\n"

}


elsif($sorgu eq "Delete_Row"){

    my $dataPath = $ARGV[1];
    my $dataName = $ARGV[2];
    my $name = $ARGV[3];
    #assigning text lines to array @LINES
    open( FILE, "<$dataPath"."/"."$dataName".'.txt' );
    my @LINES = <FILE>;
    close( FILE );
    #writing values in text without the row which was wanted to be deleted.
    open( FILE, ">$dataPath"."/"."$dataName".'.txt' );
    foreach my $LINE ( @LINES ) {
        print FILE $LINE unless ( $LINE =~ m/$name/ );
    }
    close( FILE );
    print "Successfully removed.\n";
}

elsif ($sorgu eq "Insert_Into") {
  my $dataPath = $ARGV[1];
  my $dataName = $ARGV[2];
  my $numArgs = $#ARGV + 1;
  my $valueNum = $numArgs - 3;


 my @arr=();
  for (my $var5 = 0; $var5 < $valueNum; $var5++) {
     $arr[$var5]= $ARGV[$var5+3];
}


  open( FILE, ">>", "$dataPath"."/"."$dataName".'.txt' )
  or die "Couldn't open: $!";

  print FILE "\n";
  for (my $var6 = 0; $var6 < $valueNum; $var6++) {
    print FILE  $arr[$var6]."|" ;
  }
  close(FILE);
}

elsif ($sorgu eq "Update") {

  $dbadress=splice(@ARGV,1,1);
	$dbname=$ARGV[1];
	$tablename=$ARGV[2];
	my $new=pop(@ARGV);
	my $old=pop(@ARGV);
  my $path= $dbadress."/".$dbname.'.txt';
  print "Old is  $old\n";
  print "New is $new\n";

open my $in,  '<',  $path      or die "Can't read old file: $!";
open my $out, '>', $path.'dene.txt' or die "Can't write new file: $!";

while( <$in> )
    {
      #replace old with new in every line
    s/$old/$new/g ;
      #write values temporary table
    print $out $_;
    }

close $out;
#change temporary table's name with original table.
#All changes is made as if there was no temporary table
#because temporary table is gone now.
rename $path.'dene.txt', $path ;

}

elsif($sorgu eq "Search"){
  my $dataPath = $ARGV[1];
  my $dataName = $ARGV[2];
  my $path= $dataPath."/".$dataName.'.txt';
  my $find = $ARGV[3];
  open FILE, $path;
  my @line = <FILE>;
  print "Lined that matched with $find\n";
  for (@line) {
    if ($_ =~ /$find/) {
        print "$_\n";
    }
}
}

elsif ($sorgu eq "Alter_Table"){
  my $dataPath = $ARGV[1];
  my $dataName = $ARGV[2];
  my $tableName=$ARGV[3];
  my $path= $dataPath."/".$dataName.'.txt';
  @columns=splice(@ARGV,4);

  my $newtable="";
 #getting new table name and columns from command line
  foreach my $line(@columns){
    $newtable =$line.'|'.$newtable;
    }
  $newtable='#'.$tableName."\n".$newtable;

#assigning text lines to an array
  open( FILE, "<$path" ) or die "Can't read old file: $!";
  my @LINES = <FILE>;
  close( FILE );

#re-writing table without first two line.Because first two lines are about
# old table name and columns
  open( FILE, ">$path" );
  for (my $var1 = 0; $var1 <$#LINES+1; $var1++) {
    print FILE $LINES[$var1] unless ( $var1 == 0 || $var1 == 1 );
  }
  close( FILE );
#We have a table without table name and columns.
  open my $in,  '<', $path      or die "Can't read old file: $!";
  #Open temporary table to add new table name and columns.
  open my $out, '>', $path.'dene.txt' or die "Can't write new file: $!";
   print $out $newtable."\n";
  while( <$in> )
      {
      print $out $_;
      }

  close $out;
  #rename temporary table with original one.
  rename $path.'dene.txt', $path ;
}

#Coded by Fatih Durukan.
