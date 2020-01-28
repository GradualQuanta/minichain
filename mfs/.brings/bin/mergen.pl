#!/usr/bin/perl
#BEGIN { $Exporter::Verbose=1 }

### usage :
#
#  hash = merged_m(@array_of_sorted_hashes)
#
use YAML::Syck qw(Dump);
# ---------------------------------------------------------------------
use if (exists $ENV{IPMS_HOME}), lib => $ENV{IPMS_HOME}.'/lib';
# ---------------------------------------------------------------------
#use IPMS qw(shorthash get_hash_content get_previous get_parents get_vertex extract_keywords set_keywords remove_keywords ipms_post_api);
use IPMS qw(shorthash merge_n);
use DVS qw(version);
use UTIL qw(hashr encode_base58 nonl);

our $dbug;
#understand variable=value on the command line...
eval "\$$1='$2'"while $ARGV[0] =~ /^(\w+)=(.*)/ && shift;

print "// DBUG \n" if $dbug;


use Text::Diff;
use Text::Patch;
use Text::Diff3;

if ($0 eq __FILE__) {

   my $doc1= shift || 'QmS1LcoTTkJqX5aZnCDpmBKH1HLo7cAXt3kqMuFGj1sbgw';
   my $doc2= shift || 'QmTVeuSGmV8H3HXJAk6YP6pgcb8YTZactyRkWrjoa1mh1E';
   my $hash = &merge_n($doc1,$doc2);
   printf "hash: %s\n",$hash;

   exit $?;
}

sub _vote {
  my ($xa,$xb) = @_;
  if ($xa eq $xb) {
    return ('',$xa);
  } else {
    my $diff = diff \$xa, \$xb, { STYLE => 'Unified' }; 
    return ($diff, $xa);
  }
}

1; # $Source: /my/perl/scripts/mergen.pl $
