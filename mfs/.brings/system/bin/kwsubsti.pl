#!/usr/bin/perl
# $Name: kwsubsti.pl$ ...
# $Source: /.brings/files/bin/kwsubsti.pl$
# $Date: 12/12/19$
# $previous: QmUmeXP7TdYQGMnL7GddRUQRHyrYwkPvAHTDx7rFvaCCaN$

# $tic: 1576163731$
# $spot: ~$
# $qm: z6CfPrhCREyKcfWPVAvnbPmwaAbzXHwevCFvxyyrBTCL$

# below are keywords that shouldn't work !
# $NOKEYWORD: skipped too $abc $
# $NOKEYWORD: skipped \$
# \$NOKEYWORD: skipped $
# $$NOKEYWORD: skipped $
#
# ---------------------------------------
# qm used for payload hash computation :
#ipms add keywords.txt --hash sha3-224 --cid-base base58btc
my $qmstatic='z6CfPrhCREyKcfWPVAvnbPmwaAbzXHwevCFvxyyrBTCL';

# usage: perl kwsubsti.pl keywords.yml file.txt

use YAML::Syck qw(LoadFile);
my $yamlf=shift;
my $yml = LoadFile($yamlf);
my $file=$ARGV[0];

my $spot = &get_spot($^T);

local $/ = undef;
my $buf = <>;
$buf =~ s/\$qm: [^\$]*\s*\$$/\$qm: $qmstatic\$/m;
my $qm = 'z'.&encode_base58(pack('H4','01551220').&hashr('SHA256',1,$buf));
$buf =~ s/\$qm: [^\$]*\s*\$$/\$qm: $qm\$/m; # replace w/ current qm
$buf =~ s/\$tic: [^\$]*\s*\$$/\$tic: $^T\$/m; # update timestamp
$buf =~ s/\$spot: [^\$]*\s*\$$/\$spot: $spot\$/m; # update space-time spot!

foreach my $kw (reverse sort keys %{$yml}) {
 #printf "%s: %s\n",$kw,$yml->{$kw};
 printf "%s: %s\n",$kw,$yml->{$kw};
 $buf =~ s/(?<![\\\$])\$$kw: [^\$]*\s*(?<!\\)?\$(?=['"\Z\s])?/\$$kw: $yml->{$kw}\$/gm;
 #my $KW = $kw; $KW =~ s/.*/\u$&/;
 #$buf =~ s/(?!\\)\$$KW: [^\$]*\s*\$$/\$$KW: $yml->{$kw}\$/gm;
}

print "buf: ",$buf if $dbug;

local *F;
open F,'>',$file;
print F $buf;
close F;

exit $?;

sub encode_base58 { # btc
  use Math::BigInt;
  use Encode::Base58::BigInt qw();
  my $bin = join'',@_;
  my $bint = Math::BigInt->from_bytes($bin);
  my $h58 = Encode::Base58::BigInt::encode_base58($bint);
  $h58 =~ tr/a-km-zA-HJ-NP-Z/A-HJ-NP-Za-km-z/;
  return $h58;
}
sub hashr {
   my $alg = shift;
   my $rnd = shift; # number of round to run ...
   my $tmp = join('',@_);
   use Crypt::Digest qw();
   my $msg = Crypt::Digest->new($alg) or die $!;
   for (1 .. $rnd) {
      $msg->add($tmp);
      $tmp = $msg->digest();
      $msg->reset;
      #printf "#%d tmp: %s\n",$_,unpack'H*',$tmp;
   }
   return $tmp
}
# -----------------------------------------------------------------------
sub get_spot {
   my $tic = $_[0] || $^T;
   my $dotip = &get_localip;
   printf "dotip: %s\n",$dotip;
   my $pubip = &get_publicip;
   printf "pubip: %s\n",$pubip;
   my $lip = unpack'N',pack'C4',split('\.',$dotip);
   my $nip = unpack'N',pack'C4',split('\.',$pubip);
   my $spot = $tic ^ $nip ^ $lip;
   return $spot;
}
# -----------------------------------------------------------------------
sub get_localip {
    use IO::Socket::INET qw();
    # making a connectionto a.root-servers.net

    # A side-effect of making a socket connection is that our IP address
    # is available from the 'sockhost' method
    my $socket = IO::Socket::INET->new(
        Proto       => 'udp',
        PeerAddr    => '198.41.0.4', # a.root-servers.net
        PeerPort    => '53', # DNS
    );
    return '0.0.0.0' unless $socket;
    my $local_ip = $socket->sockhost;

    return $local_ip;
}
# -----------------------------------------------------------------------
sub get_publicip {
 use LWP::UserAgent qw();
  my $ua = LWP::UserAgent->new();
  my $url = 'http://iph.heliohost.org/cgi-bin/remote_addr.pl';
     $ua->timeout(7);
  my $resp = $ua->get($url);
  my $ip;
  if ($resp->is_success) {
    my $content = $resp->decoded_content;
    chomp($content);
    $ip = $content;
  } else {
    print "X-Error: ",$resp->status_line;
    my $content = $resp->decoded_content;
    $ip = '127.0.0.1';
  }
  return $ip;
}
# -----------------------------------------------------------------------

1;
