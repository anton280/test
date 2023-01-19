#!/usr/bin/perl
print "Content-Type: text/html\n\n";

#use warnings;
use DBI;
require './lib.pm';

$MAX_LINES=100;

#=tmp
$fn='./search.html';
if(open($file,"$fn")){
 $html=join '',<$file>;
 close $file;
}else{
 print "ERROR open: $fn - $!";
 exit;
}

%INPUT=&get_env();
$query=$INPUT{'query'};

$html=~s/#query#/$query/g;
print $html;

exit if !$query;

#=cut
#$query='ggivvlar@gmail.com';

&mysql_connect(); 

$query=$dbh->quote($query);


$sth=$dbh->prepare("SELECT created,int_id,str FROM log WHERE address=$query ORDER BY created DESC, int_id DESC LIMIT $MAX_LINES");
$sth->execute;

@out=();
while($hash_ref=$sth->fetchrow_hashref){
 $int_id=$hash_ref->{int_id};
 push @out,$hash_ref->{created}.' '.$hash_ref->{str};

 $sth2=$dbh->prepare("SELECT created,str FROM message WHERE int_id='$int_id' ORDER BY created DESC, int_id DESC LIMIT $MAX_LINES");
 $sth2->execute;
 while($hash_ref2=$sth2->fetchrow_hashref){
  push @out,$hash_ref2->{created}.' '.$hash_ref2->{str};
 }
 if(@out>$MAX_LINES){
  print "\n<h3>Showing the first $MAX_LINES lines</h3>\n";
  $#out=$MAX_LINES-1;
  last;
 }
}

print join "<br />\n",@out;

$dbh->disconnect();
exit;

