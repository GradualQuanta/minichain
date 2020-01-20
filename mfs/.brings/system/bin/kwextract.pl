#!/usr/bin/perl
# $Source: /my/perl/script/kwextract.pl,v$
# $Date: $
# $mutable: /.brings/system/bin/kwextract.pl$
# $previous: QmU1RDLsAGNPVuwDjKD3RQx7R6aEuQfcmSiubviDZ2XRVC$
#
# $parents: QmRU26t5KP5QLiNbjWMxSbyfaARvzshfdzozj6M4K73auH$
# $tic: 1579258505$

our $dbug=0;
#--------------------------------
# -- Options parsing ...
#
my $yml = 0;
while (@ARGV && $ARGV[0] =~ m/^-/)
{
  $_ = shift;
  #/^-(l|r|i|s)(\d+)/ && (eval "\$$1 = \$2", next);
  if (/^-d(?:e?bug)?/) { $dbug= 1; }
  elsif (/^-k(?:ey)?+(\w+)?$/) { $key= $1 ? "$1" : shift || 'source' }
  elsif (/^-y(?:ml)?/) { $yml= 1; }
  else                  { die "Unrecognized switch: $_\n"; }

}
#understand variable=value on the command line...
eval "\$$1='$2'"while $ARGV[0] =~ /^(\w+)=(.*)/ && shift;



my $keywords = {};
my $file=shift;
if (-e $file) {
   # extraction of RCS keyword source
   open F,'<',$file; local $/ = undef;
   my $buf = <F>; $buf =~ s/\$qm: .*\s*\$/\$qm: ~\$/;
   my $qm = 'z'.&encode_base58(pack('H4','01551220').&hashr('SHA256',1,$buf));
	 $keywords->{qm} = $qm;
   seek(F,0,0);
   $/ = "\n";
   while (<F>) {
      if (m/\$([A-Z]\w+):.*\$/) { # User's keywords ...
         printf "line: %s",$_ if $dbug;
         # $ not preceded w/ \ or $
         # last $ not preceded w/ \ and followed by ' " or \s
         if (m/(?<![\\\$])\$([A-Z]\w+):\s*([^\\\$]*?)\s*(?<!\\)?\$(?=['"\Z\s])/) { # keywords value
            printf "debug: \$&=%s\n",$& if $dbug;
            printf "debug: %s %s\n",$1,$2 if $dbug;
            $keywords->{$1} = $2;
         }
      } elsif (m/(?<!\\)\$(qm|source|parents|mutable|previous|next|tic|spot):\s*([^\\\$]*?)\s*\$(?=['"\Z\s])/) { # reserved
         #printf "debug: %s %s\n",$1,$2 if $dbug;
         my $keyw=lc($1);
         $keywords->{$keyw} = $2;
      } else {
         chomp;
         #printf "dbug: %s\n",$_ if $dbug;
      }
   }
   close F;
   # if no mutable invent one !
   if (! defined $keywords->{mutable}) {
      if ($file =~ m{^/.*/([^/]+)/([^/]+)/?$}) {
         my $mutable = $1.'/'.$2.'.log'; $mutable =~ s,/_,/,g;
         $keywords->{mutable} = '/my/etc/mutables/'.$mutable;

      } else {
         use Cwd qw(cwd);
         cwd() =~ m{/([^/]+)/?$};
         my $mutable = $1.'/'.$file.'.log'; $mutable =~ s,/_,/,g;
         $keywords->{mutable} = '/my/etc/mutables/'.$mutable;
      }
   }
   # if no source invent one !
   if (! defined $keywords->{Source} || $keywords->{Source} eq '') {
      if ($file =~ m{^/.*/([^/]+)/([^/]+)/?$}) {
         my $source = $1.'/'.$2; $source =~ s,/_,/,g;
         $keywords->{Source} = '/my/files/'.$source;
      } else {
         use Cwd qw(cwd);
         cwd() =~ m{/([^/]+)/?$};
         my $source = $1.'/'.$file; $source =~ s,/_,/,g;
         $keywords->{Source} = '/my/files/'.$source;
      }
   }


} else {
  $source=$file||'/from/the/ultimate/divine/source/empty_file.blob,v';
}

if ($yml) {
   use YAML::Syck qw(Dump);
   printf "%s\n",Dump($keywords);
} elsif (defined $key) {
   if (defined $keywords->{$key}) {
      print $keywords->{$key};
   } else {
      print '~';
   }
} elsif (defined $keywords->{'mutable'}) {
   print $keywords->{mutable};
} else {
   print $keywords->{Source};
}

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


1;
