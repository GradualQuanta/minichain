#!/usr/bin/perl
use LWP::UserAgent;
use HTTP::Request::Common;

# script to write data on mfs !
#
# usage:
#  perl issue_solved.pl
#
#  verify file is actually on mfs side !
#  ipfs --api /ip4/127.0.0.1/tcp/5001 files read /my/files/data.txt

my $filepath='./data.txt';
my $filename="/my/files/data.txt";
my $data="hello, World!\n-- $$\nmichelc\@gc-bank.org\n";
#y $url="http://127.0.0.1:5001/api/v0/add?arg=$filename";
my $url="http://127.0.0.1:5001/api/v0/files/write?arg=$filename&create=1&parents=1";

my $endpoint;
   $endpoint='https://iph.heliohost.org/cgi-bin/posted.pl?cmd=';
   $endpoint='https://postman-echo.com/post?cmd=';
   $endpoint='http://127.0.0.1:5001/api/v0/files/';
my $url=sprintf'%swrite?arg=%s&create=1&parents=1',$endpoint,$filename;
my $ua = LWP::UserAgent->new();

my $form = [
#      $filename => ["$filepath" => "$filename" ]
#      'file' => ["$filepath" => "$filename" ]
#      'file0' => ["$filepath" => "$filename~0" ],
#      'file1' => ["$filepath" => "$filename~1", Content => "$data" ],
      'file' => $data
   ];
my $request = POST($url,
  'Content-Type' => 'multipart/form-data;boundary=-----a-special-boundary-543-67',
  'Content' => $form);

printf "request: %s.\n",YAML::Syck::Dump($request);

my $resp = $ua->request($request);
printf "X-Status: %s\n",$resp->status_line;
if ($resp->is_success) {
my $content = $resp->decoded_content;
if ($content =~ m/^{/) { # }
 use YAML::Syck qw();
 use JSON qw(decode_json);
 my $json = decode_json($content);
 printf "content: %s.\n",YAML::Syck::Dump($json);
} else {
printf "X-content: %s\n",$content;
}
# ...
} else {
printf "X-content: %s\n",$resp->decoded_content;
}

exit $?;
1; # $Source: /my/perl/scripts/issue_solved.pl$
