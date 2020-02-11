#!/usr/bin/perl

# This code is for uploading a file to IPFS via the http api


use lib $ENV{IPMS_HOME}.'/lib';
use UTIL qw(hashr encode_base58);
use IPMS qw(ipms_post_api get_apihostport);
use YAML::Syck qw(Dump);

#understand variable=value on the command line...
eval "\$$1='$2'"while $ARGV[0] =~ /^(\w+)=(.*)/ && shift;


my $buf = "$^T: this is the data to be writen to IPFS!\n-- $$\n";

my $options = '&create=1&parents=0';
my $mh = &_ipms_post_api('files/write','/var/tmp/data.txt',$buf,$options);
if (ref($mh) eq 'HASH') {
  printf "write: %s\n",Dump($mh);
} else {
  printf "write: %s\n",$mh;
}
exit $?;

sub _ipms_post_api {
   my $cmd = shift;
   my $filename = shift;
   my $data = shift;
   my $opt = join'',@_;
   my $filepath = '/tmp/blob.data';
   my $api_url;
   # select endpoints:
   if ($ENV{HTTP_HOST} =~ m/heliohost/) { # for debug purpose !
      $api_url = 'https://iph.heliohost.org/cgi-bin/posted.pl?cmd=%s&arg=%s%s';
   } elsif ($ENV{HTTP_HOST} =~ /postman/) {
      $api_url = 'https://postman-echo.com/post?cmd=%s&arg=%s%s';
   } elsif ($ENV{HTTP_HOST} =~ /127.0.0.1/) {
      $api_url = 'http://127.0.0.1:8088/GITrepo/websites/helio/cgi-bin/posted.pl?cmd=%s&arg=%s%s';
   } elsif ($ENV{HTTP_HOST} =~ m/heliohost/) {
      $api_url = sprintf'https://%s/api/v0/%%s?arg=%%s%%s','ipfs.blockringtm.ml';
   } else {
      my ($apihost,$apiport) = &get_apihostport();
      $api_url = sprintf'http://%s:%s/api/v0/%%s?arg=%%s%%s',$apihost,$apiport;
   }
   my $url;
   if ($cmd eq 'add') {
      $url = sprintf $api_url,$cmd,$filepath,$opt; # name of type="file"
   } elsif ($cmd =~ m/write$/) {
      $url = sprintf $api_url,'add',$filename,$opt; # hack : add instead of files/write
   } else {
      my $sha2 = &hashr('SHA256',1,$data);
      return 'z'.encode_base58(pack('H8','01551220').$sha2);
   }
   use IPMS qw(ipms_api);
   use JSON qw(decode_json);
   use LWP::UserAgent qw();
   use HTTP::Request 6.07;
   use MIME::Base64 qw(encode_base64 decode_base64);
   my $ua = LWP::UserAgent->new();
   my $form = [
#        Content_Type => 'multipart/form-data',
#       You are allowed to use a CODE reference as content in the request object passed in.
#       The content function should return the content when called. The content can be returned
#       Content => [$filepath, $filename, Content => $data ]
      'file' => ["$filepath" => "$filename", Content => "$data" ]
#      'file' => ["$filepath" => "$filename" ]
   ];
   if ($dbug) {
      printf "\$url: %s\n",$url;
      printf "\@form: %s.\n",Dump($form);
   }

    #my $resp = $ua->post($url,$form, 'Content_Type' => 'form-data');
    my $resp = $ua->post($url,$form, 'Content-Type' => 'multipart/form-data;boundary=123-soleil');
   if ($resp->is_success) {
      # printf "X-Status: %s<br>\n",$resp->status_line;
      $content = $resp->decoded_content;
      # ---------------------------------------------------------------------
      if ($cmd eq 'files/write') { # QUICK HACK as write doesn't work yet !
        $content =~ s/}\s*{/},{/g;
        $content = "[$content]";
        printf qq'content: "%s"\n',$content;
        my $json = &decode_json($content);
        my $qm = $json->[0]{Hash};
        my $mh = &ipms_api('files/cp',"/ipfs/$qm","&arg=$filename");
        return ($mh ne '') ? $mh : $json->[0];
      }
      # ---------------------------------------------------------------------
   } else { # error ... 
      print "<pre>";
      printf "X-api-url: %s\n",$url;
      printf "Status: %s\n",$resp->status_line;
      $content = $resp->decoded_content;
      local $/ = "\n";
      chomp($content);
      printf "Content: %s\n",$content;
      print "</pre>\n";
   }
#printf qq'content: "%s"\n',$content;
   if ($content =~ m/^{/) {
      my $resp = &decode_json($content);
      return $resp;
   } else {
      return $content;
   }

}

1;
