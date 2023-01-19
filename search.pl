#!/usr/bin/perl
print "Content-Type: text/html\n\n";

#use warnings;
use DBI;
require './lib.pm';



=tmp
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

=cut

$query='ggivvlar@gmail.com';


&mysql_connect(); 

$query=$dbh->quote($query);

$limit=100;

=dep
$q=qq|SELECT count(*) FROM log WHERE address=$query|;
$sth=$dbh->prepare($q);
$sth->execute;
$total=$sth->fetchrow_hashref->{'count(*)'};

print "<h3>The first $limit of $total results are shown</h3>" if $total>$limit;
=cut

$q=qq|SELECT created,int_id,str FROM log WHERE address=$query ORDER BY created DESC, int_id DESC LIMIT $limit|;

$sth=$dbh->prepare($q);
$sth->execute;
$count=0;
while($hash_ref=$sth->fetchrow_hashref){
# $timestamp=$hash_ref->{created};
 $int_id=$hash_ref->{int_id};
# $str=$hash_ref->{str};
# print "$timestamp $str<br>\n";
 print $hash_ref->{created}.' '.$hash_ref->{str}."<br>\n";
 if(++$count>=$limit

#=tmp
 $q=qq|SELECT created,str FROM message WHERE int_id='$int_id' ORDER BY created DESC, int_id DESC LIMIT $limit|;
 $sth2=$dbh->prepare($q);
#print $q."<br>\n";
 $sth2->execute;
 while($hash_ref2=$sth2->fetchrow_hashref){
  print $hash_ref2->{created}.' '.$hash_ref2->{str}."<br>\n";
 }
#=cut
}


# use Data::Dumper; print '<pre>'.Dumper(\$sth).'</pre>';# exit;

# $Rows=$sth->rows;

#print "\n\n<br /> [[ $r | $Rows ]]";
#print 1111111111111111111;

$dbh->disconnect();
exit;

