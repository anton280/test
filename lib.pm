$DB_NAME='xxx_db';
$DB_USER='yyy';
$DB_PASS='zzz';
################################################################################
sub mysql_connect{
 unless($dbh = DBI->connect(
	"dbi:mysql:database=$DB_NAME;mysql_enable_utf8=1",
	$DB_USER,
	$DB_PASS,
	{
		RaiseError              => 1,
		AutoCommit              => 1,
		mysql_multi_statements  => 1,
		mysql_init_command      => q{SET NAMES 'utf8';SET CHARACTER SET 'utf8'}
	}
 )){ print "Cannot connect $DBI::errstr";exit}
}
################################################################################
sub get_env{
 my($buf,$val,$name,$i,@fval,%INPUT)=();
 if($ENV{'REQUEST_METHOD'} eq 'POST'){read(STDIN,$buf,$ENV{'CONTENT_LENGTH'})}
 else{$buf=$ENV{'QUERY_STRING'}}
 if($buf ne ""){
  @fval=split(/&/,$buf);
  foreach $i(0..$#fval){
   ($name,$val)=split(/=/,$fval[$i],2);
   $val=~tr/+/ /;
   $val=~ s/%(..)/pack("c",hex($1))/ge;
   $name=~tr/+/ /;
   $name=~s/%(..)/pack("c",hex($1))/ge;
   if(!defined($INPUT{$name})){$INPUT{$name}=$val}
   else{$INPUT{$name}.=",$val"}
  }
 }
 return %INPUT;
}
################################################################################

