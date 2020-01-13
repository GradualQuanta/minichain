#!/usr/bin/env perl
BEGIN { our $brsdir = (__FILE__ =~ m{(.*+)/}) ? "$1" : '..'; }
# $Source: /my/perl/script/hstamp.pl$
# $mtime: 1577480412 $

our $dbug=0;
#understand variable=value on the command line...
eval "\$$1='$2'"while $ARGV[0] =~ /^(\w+)=(.*)/ && shift;
printf "@INC: (%s)\n",join(', ',@INC) if $dbug;

my $mtime = &kwx(*DATA,'mtime'); # /!\ need __END__
printf "--- # %s %.2f\n",(&fname($0))[2], scalar &rev($mtime);
printf "date: %s\n",&hdate($mtime);
printf "stamp: %s\n",&stamp();
exit $?;

# -----------------------------------------------------------------------
sub kwx {
  local *fd = shift;
  my $key = $_[0];
  my $p = tell(fd);
  #printf "p: %s\n",$p;
  seek(fd,0,0);
  local $/ = "\n";
  my $kw= {};
  while (<fd>) {
    #printf "dbug: %s",$_;
    if (m/\$(\w+): +([^\$]+)\s*\$/) {
      $kw->{$1} = $2;
      printf "info: %s %s\n",$1,$2 if $dbug;
    }
  }
  seek(fd,$p,0);
  return $kw->{$key};
}
# -----------------------------------------------------------------------
sub fname {
   my $file = shift;
   my $s = rindex($file,'/');
   my $fpath = substr($file,0,$s);
   my $fname = substr($file,$s+1);
   my $p = rindex($fname,'.');
   my ($bname,$ext);
   if ($p < 0) {
      $bname = $fname; $ext = '';	  
   } else {
      $bname = substr($fname,0,$p);
      $ext = substr($fname,$p+1);
   }
   if (0) {
      printf "fpath: %s\n", $fpath;
      printf "fname: %s\n", $fname;
      printf "bname: %s\n", $bname;
      printf "ext: %s\n", $ext;
   }
   return ($fpath,$fname,$bname,$ext);
}
# -----------------------------------------------------------------------
sub rev {
  my ($sec,$min,$hour,$mday,$mon,$yy,$wday,$yday) = (localtime($_[0]))[0..7];
  my $rweek=($yday+&fdow($_[0]))/7;
  my $rev_id = int($rweek) * 4;
  my $low_id = int(($wday+($hour/24)+$min/(24*60))*4/7);
  my $revision = ($rev_id + $low_id) / 100;
  return (wantarray) ? ($rev_id,$low_id) : $revision;
}
# -----------------------------------------------------------------------
sub fdow {
   my $tic = shift;
   use Time::Local qw(timelocal);
   ##     0    1     2    3    4     5     6     7
   #y ($sec,$min,$hour,$day,$mon,$year,$wday,$yday)
   my $year = (localtime($tic))[5]; my $yr4 = 1900 + $year ;
   my $first = timelocal(0,0,0,1,0,$yr4);
   $fdow = (localtime($first))[6];
   #printf "1st: %s -> fdow: %s\n",&hdate($first),$fdow;
   return $fdow;
}
# -----------------------------------------------------------------------
sub hdate { # return HTTP date (RFC-1123, RFC-2822) 
   my ($time,$delta) = @_;
   my $stamp = $time+$delta;
   my $tic = int($stamp);
   #my $ms = ($stamp - $tic)*1000;
   my $DoW = [qw( Sun Mon Tue Wed Thu Fri Sat )];
   my $MoY = [qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec )];
   my ($sec,$min,$hour,$mday,$mon,$yy,$wday) = (gmtime($tic))[0..6];
   my ($yr4,$yr2) =($yy+1900,$yy%100);

   # Mon, 01 Jan 2010 00:00:00 GMT
   my $date = sprintf '%3s, %02d %3s %04u %02u:%02u:%02u GMT',
   $DoW->[$wday],$mday,$MoY->[$mon],$yr4, $hour,$min,$sec;
   return $date;
}
# -----------------------------------------------------------------------
sub stamp { # Hash-like date timestamp
   my $tic = time();
   my ($sec,$min,$hour,$mday,$mon,$yy,$wday,$yday) = (localtime($tic))[0..7];
   # pseudo-day normalized date signature (not Gregorian-style)
   my $ddate = 365 * $yy + 30 * $mon + $yday;
   printf "ddate: %s\n",$ddate;
   my $tdate = 3600 * $hour + 60 * $min + $sec; # Second normalized time signature
   printf "tdate: %s\n",$tdate;
   local *DATE; open(DATE, "date +%N |"); my $theDate = <DATE>; close(DATE);
   my $nsdate = int($theDate); # Nanosecond normalized time
   printf "nsdate: %s\n",$nsdate;
   my $xdate = $ddate ^ $tdate ^ $nsdate; # Combinate signatures by xor
   my $pdate = pack("a*", $xdate); # Pack signature to a string
   return $pdate;
}
# -----------------------------------------------------------------------
1;
__END__
