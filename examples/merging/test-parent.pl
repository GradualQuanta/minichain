#!/usr/bin/perl

BEGIN { $Exporter::Verbose=0 }
# ---------------------------------------------------------------------
use if (exists $ENV{IPMS_HOME}), lib => $ENV{IPMS_HOME}.'/lib';
# ---------------------------------------------------------------------
use IPMS qw(get_hash_content extract_keywords);


if ($0 eq __FILE__) {
  my $node;
     $node = 'QmdKVrvhDpewWN7Ns3xsAhoG5iHRJU4D3sB7oPKtSDtFEg';
     $node = 'QmQShNe7PipWjFahzLkhoeVMY7CZAujRpFMzpyHWmwyaKJ';
     $node = 'QmbPtZtmdmP6TQbGFHEKhPVVqMod93ouf9ih6XhSN63naT';
     $node = 'Qmc7b5JaLCxiQKRTWUeMLUCiEWYJA6NgGDpiN9WTbfQPGU';
  my $parents = &get_parents($node);
  printf "parents: [%s]\n",join',',@$parents;
}

sub get_parents { # all parents are nodes
  my $n = shift;
  my $buf = &get_hash_content($n);
  #printf "content(%s): %s.\n",$n,nonl($buf,0,76);
  my $prev = &extract_keywords($buf,'parents');
  return $prev;
}

1;
