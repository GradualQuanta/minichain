#!/usr/bin/env perl


our $dbug=0;
#--------------------------------
# -- Options parsing ...
#
my $all = 0;
while (@ARGV && $ARGV[0] =~ m/^-/)
{
  $_ = shift;
  #/^-(l|r|i|s)(\d+)/ && (eval "\$$1 = \$2", next);
  if (/^-v(?:erbose)?/) { $verbose= 1; }
  elsif (/^-d(?:e?bug)?/) { $dbug= 1; }
  elsif (/^-a(?:ll)?/) { $all= 1; }
  elsif (/^-y(?:ml)?/) { $yml= 1; }
  else                  { die "Unrecognized switch: $_\n"; }

}
#understand variable=value on the command line...
eval "\$$1='$2'"while $ARGV[0] =~ /^(\w+)=(.*)/ && shift;

use YAML::Syck qw();
# get hash as argument or stdin

if (@ARGV) {
 $hash = shift;
} else {
 $hash = <STDIN>;
 chomp($hash);
}
$hash =~ s,.*/ip[fhnm]s/,,;
$hash = 'Qm123' unless $hash;
print "hash: $hash:\n" if $all;

# ----------------------------------------------------------------
# decode data (keep only the binary-hash value
my $bindata = "\0";
if ($hash =~ m/^Qm/) {
 $bindata = &decode_base58($hash);
 printf "mh58: %s (%uc, %uB) : f%s...\n",$hash,length($hash),
        length($bindata), substr(unpack('H*',$bindata),0,11) if $dbug;
 $bindata = substr($bindata,-32); # remove header
 printf "bin: %s\n",unpack'H*',$bindata if $all;
# ----------------------------------------------------------------
} elsif ($hash =~ m/^z[bd]/) {
 $bindata = &decode_base58(substr($hash,1));
 printf "zb58: %s (%uc, %uB) : f%s...\n",$hash,length($hash),
 length($bindata), substr(unpack('H*',$bindata),0,11) if $dbug;
 my $cid = substr($bindata,0,2);
 if ($cid eq "\x01\x55" || $cid eq "\x01\x70") {
   #my $header = substr($bindata,0,4);
   $bindata = substr($bindata,4);
 } else {
   $bindata = substr($bindata,2); # remove header
 }
printf "sha2: f%s\n",unpack('H*',$bindata) if $dbug;
# ----------------------------------------------------------------
} elsif (-e $hash) { # if key is a file do a sha2 on its content
  local *F; open F,'<',$hash; binmode(F) unless $hash =~ m/.txt$/o; 
  local $/ = undef; my $buf = <F>; close F;
  $bindata = &hashr('SHA-256',1,$buf); # SHA-256 if cleartext !
  printf "get_sha2(%s): %s\n",$hash,unpack('H*',$bindata) if $dbug;
# ----------------------------------------------------------------
} else { # if key is plain text ... do a sha2 on it
  $hash =~ s/\\n/\n/g;
  $hash .= ' '.join' ',@ARGV if (@ARGV);
  $bindata = &hashr('SHA-256',1,$hash); # SHA-256 if cleartext !
  printf "sha2(%s): %s\n",$hash,unpack('H*',$bindata) if $dbug;
}
# ----------------------------------------------------------------
my $sha16 = unpack('H*',$bindata);
my $id7 = substr($sha16,0,7);
printf "id7: %s\n",$id7 if $all;

my $build = &word(unpack'n',$bindata);

if ($all) {
printf "build: %s\n",$build;
} else {
printf "%s\n",$build;
}
#printf "https://robohash.org/%s.png/set=set4&bgset=bg1&size=120x120&ignoreext=false\n",$word;

if ($all) {
   print "tic: $^T\n"
}

exit $?;

# -----------------------------------------------------------------------
sub decode_base58 {
  use Math::BigInt;
  use Encode::Base58::BigInt qw();
  my $s = $_[0];
  # $e58 =~ tr/a-km-zA-HJ-NP-Z/A-HJ-NP-Za-km-z/;
  $s =~ tr/A-HJ-NP-Za-km-z/a-km-zA-HJ-NP-Z/;
  my $bint = Encode::Base58::BigInt::decode_base58($s);
  my $bin = Math::BigInt->new($bint)->as_bytes();
  return $bin;
}
# --------------------------------------------
sub hashr {
   my $alg = shift;
   my $rnd = shift;
   my $tmp = join('',@_);
   use Digest qw();
   my $msg = Digest->new($alg) or die $!;
   for (1 .. $rnd) {
      $msg->add($tmp);
      $tmp = $msg->digest();
      $msg->reset;
   }
   return $tmp
}
# -----------------------------------------------------------------------
sub word { # 20^4 * 6^3 words (25bit worth of data ... 3.4bit per letter)
   use integer;
   my $n = $_[0];
   printf "n: %s\n",$n if $dbug;
   my $vo = [qw ( a e i o u y )]; # 6
   my $cs = [qw ( b c d f g h j k l m n p q r s t v w x z )]; # 20
   my $str = '';
   if (1 && $n < 26) {
      $str = chr(ord('a') +$n%26);
   } else {
      $n -= 6;
      while ($n >= 20) {
         my $c = $n % 20;
         $n /= 20;
         $str .= $cs->[$c];
	 #print "cs: $n -> $c -> $str\n" if $dbug;
         my $c = $n % 6;
         $n /= 6;
         $str .= $vo->[$c];
	 #print "vo: $n -> $c -> $str\n" if $dbug;
      }
      if ($n > 0) {
         $str .= $cs->[$n];
      }
   }
   return $str;
}
# -----------------------------------------------------------------------
1; # $Source: /my/perl/scriptes/buildname.pl$
