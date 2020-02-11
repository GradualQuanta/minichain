#!/usr/bin/perl

# This code is for uploading data to IPFS via the http api

use lib $ENV{IPMS_HOME}.'/lib';
use UTIL qw(hashr encode_base58);
use IPMS qw(ipms_post_api);
use YAML::Syck qw(Dump);

#understand variable=value on the command line...
eval "\$$1='$2'"while $ARGV[0] =~ /^(\w+)=(.*)/ && shift;


my $mh;
my $buf = "$^T: this is the file to be loaded to IPFS!\n-- $$\n";
printf "buf: %s.\n",$buf;
my $options = '&raw-leaves=true&fscache=true&cid-version=1&cid-base=base58btc';
#  $options .= '&only-hash=true'; # this option makes ipfsd failed
# 11:34:07.391 ERROR       core: failure on stop:  context canceled; TODO: mock repo builder.go:47
if (0) {
   $options .= '&wrap-with-directory=false&chunker=size-262144';
   $mh = &ipms_post_api('add','blob.txt',$buf, $options);
} else {
   $options .= '&create=true&truncate=true';
   $mh = &ipms_post_api('files/write','/tmp/blob.txt',$buf, $options);
}
if (ref($mh) eq 'HASH') {
  printf "mh: %s\n",Dump($mh);
} else {
  printf qq'mh: "%s"\n',$mh;
}

exit $?;

1; # $Source: /my/perl/script/api.pl$
