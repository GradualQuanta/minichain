#!/usr/bin/perl

# ----------------------------------------------------------------
our $wordlists;
my $qmDICT = 'QmNYxFBCcUKEmjLF578pCKvrFHDfYdTtwZaLm8byBhFVHG';
my $fnamelist = &load_qmlist('fnames');
my $lnamelist = &load_qmlist('lnames');

use YAML::Syck qw(Dump);
use lib $ENV{IPMS_HOME}.'/lib';
use IPMS qw(ipms_api);

#printf "fl: %s.\n",Dump($fnamelist);

printf "ll: %s.\n",Dump($lnamelist);
exit $?;
# -----------------------------------------------------------------------
sub load_qmlist {
   my $wlist = shift;
   if (! exists $wordlists->{$wlist}) {
      $wordlists->{$wlist} = [];
   }
   # ------------------------------
   my $wordlist = $wordlists->{$wlist};
   my $wl = scalar @$wordlist;
   if ($wl < 1) {
      my $file;
      my $buf = &ipms_api('cat',"/ipfs/$qmDICT/$wlist.txt");
      return undef if ($buf eq '');
      @$wordlist = grep !/^#/, split("\n",$buf);
      $wl = scalar @$wordlist;
      #printf "wlist: %s=%uw\n",$wlist,$wl;
   }
  return $wordlist;
}
# -----------------------------------------------------------------------
1;
