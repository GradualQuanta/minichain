#!/usr/bin/perl

# 

# get you space and time location (memory drop point)
my $tic = $^T;
printf "tic: %s\n",$tic;
my $spot = &get_spot($tic);
printf "spot: %s\n",$spot;

#use lib $ENV{IPMS_HOME}.'/lib';
#use UTIL qw(get_localip get_publicip encode_base58 hashr version get_qmhash);

exit $?;
# -----------------------------------------------------------------------
sub get_spot {
   my $tic = shift;
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
