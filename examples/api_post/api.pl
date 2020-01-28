#!/usr/bin/perl

# This code is for uploading a file to IPFS via the http api


use lib $ENV{IPMS_HOME}.'/lib';
use UTIL qw(hashr encode_base58);
use IPMS qw(ipms_post_api get_apihostport);
use YAML::Syck qw(Dump);

my $options = '&raw-leaves=true&fscache=true&cid-version=1&cid-base=base58btc';
#  $options .= '&only-hash=true'; # this option makes ipfsd failed
# 11:34:07.391 ERROR       core: failure on stop:  context canceled; TODO: mock repo builder.go:47
  $options .= '&wrap-with-directory=false&chunker=size-262144';
my $mh = &ipms_post_api('add',"$$: this is the data to be loaded to IPFS!",$options);
printf "mh: %s\n",Dump($mh);
exit $?;

sub _ipms_post_api {
  my $cmd = shift;
  my $data = shift;
  my $filename = 'blob.data';
  my $filepath = '/tmp/blob.data';
  if ($cmd eq 'add') {
     my $api_url;
     if ($ENV{HTTP_HOST} =~ m/localhost/) { # for debug purpose !
        $api_url = 'https://iph.heliohost.org/cgi-bin/posted.pl?cmd=%s&arg=%s%s';
     } elsif ($ENV{HTTP_HOST} =~ m/heliohost/) {
        $api_url = sprintf'https://%s/api/v0/%%s?arg=%%s%%s','ipfs.blockringtm.ml';
     } else {
        my ($apihost,$apiport) = &get_apihostport();
        $api_url = sprintf'http://%s:%s/api/v0/%%s?arg=%%s%%s',$apihost,$apiport;
     }
     my $url = sprintf $api_url,$cmd,$filepath,@_; # name of type="file"
     printf "url: %s\n",$url;
        use LWP::UserAgent qw();
     use HTTP::Request 6.07;
     use MIME::Base64 qw(encode_base64 decode_base64);
     my $ua = LWP::UserAgent->new();
     my $form = [
#        Content_Type => 'multipart/form-data',
#       You are allowed to use a CODE reference as content in the request object passed in.
#       The content function should return the content when called. The content can be returned
#       Content => [$filepath, $filename, Content => $data ]
       'file-to-upload' => ["$filepath" => "$filename", Content => "$data" ]
     ];
     if ($dbug) {
        printf "\$url: %s\n",$url;
        printf "\@form: %s.\n",Dump($form);
     }

#    $ua->content($data);
#    my $resp = $ua->post($url,$form, 'Content_Type' => 'form-data');
     my $resp = $ua->post($url,$form, 'Content-Type' => 'multipart/form-data;boundary=123-soleil');
     if ($resp->is_success) {
#       printf "X-Status: %s<br>\n",$resp->status_line;
        $content = $resp->decoded_content;
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
     use JSON qw(decode_json);
     my $resp = &decode_json($content);
     return $resp;

  }
  my $sha2 = &hashr('SHA256',1,$data);
  return 'z'.encode_base58(pack('H8','01551220').$sha2);
}

1;
