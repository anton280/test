#!/usr/bin/perl

#use warnings;
use DBI;
require './lib.pm';

&mysql_connect();

open($outfile, "out" ) or die "couldn't open file `out` - $!\n";

while(<$outfile>){
 chomp;
 ($date,$time,$int_id,$flag,$email,$other)=split ' ',$_,6;

 $str="$int_id $flag $email $other";
 if($str){$str=$dbh->quote($str)}
 else{$str="''"}

 if($flag eq '<='){
  ($id)=$other=~/\bid=([^\s]+)\b/;
  if($id){
   $q=qq|INSERT INTO message
	(id,	created,	int_id,		str) VALUES
	('$id',	'$date $time',	'$int_id',	$str)
   |;
  }
 }else{
  $q=qq|INSERT INTO log
	(created,		int_id,		address,	str) VALUES
	('$date $time',		'$int_id',	'$email',	$str)
  |;
 }

 eval{ $dbh->do($q); };
 if($@){
  print "ERROR: $@ - $q\n";
 }

}

close $outfile;
$dbh->disconnect();
exit(0);

