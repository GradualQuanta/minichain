#!/usr/bin/perl

# usage :
# 
use lib $ENV{IPMS_HOME}.'/lib';

our $dbug = 1;
if ($dbug) {
  eval 'use YAML::Syck qw(Dump);';
}
use IPMS qw(ipms_api);

my $hash;
my $addr = shift;
# bifurcation depending on address type
if ($addr =~ m{^(?:self@)?(?:mfs:|/files)(/.*)})  {
# local mutable address of type:
# . self@mfs:/mfspat
# . mfs:/mfspat
# . /files/mfspat (webui)
  $hash = &ipms_local_mutable_resolve('mfs:'.$1);

} elsif ($addr =~ m{\w+:(/ipns/.*)} ) { # P2P request 127.0.0.1:808)
  # dweb:/ipns/mkey (mutable)
  $hash = &ipms_name_resolve($1);
} elsif ($addr =~ m{ipfs:/(/.*)} ) { # immutable
  # ipfs://mhash
  $hash = &ipms_path_resolve('/ipfs'.$1);
} elsif ($addr =~ m{(/ipfs/.*)} ) { # immutable
  # /ipfs/mhash
  $hash = &ipms_path_resolve($1);
} elsif ($addr =~ m{(\w+)\@ipms:(/.*)} ) { # remote
  # nickname@ipms:/my/identity/public.yml
  $hash = &ipms_remote_mutable_resolve($1,$2);
} elsif ($addr =~ m{/ipms/(\w+)(/.*)} ) { # remote, using nickname
  # /ipms/nickname/path
  # /ipms/symbol/path
  $hash = &ipms_remote_mutable_resolve($1,$2);
} elsif ($addr =~ m{(\w+)\@mfs:(/.*)} ) { # remote, using keys
  # peeridkey@mfs:/mfspath
  # symbolkey@mfs:/mfspath
  $hash = &mfs_remote_mutable_resolve($1,$2);
} else {
  $hash = &mfs_unknow_resolve($addr);
}

printf "hash: %s\n",$hash;
exit $?;

sub ipms_local_mutable_resolve {
  my $mfs_path = shift;
     $mfs_path =~ s/^mfs://;
  #printf "mfs: %s\n",$mfs_path;
  my $mh = &ipms_api('files/stat',$mfs_path,'&hash=1');
  #printf "%s: %s.\n",(caller(0))[3],Dump($mh) if $dbug;
  return '/ipfs/'.$mh->{Hash};

}
sub ipms_path_resolve {
  my $ipath = shift;
  my $mh = &ipms_api('resolve',$ipath);
  printf "%s.\n",Dump($mh) if $dbug;
  return $mh->{Path};
}
sub mfs_unknow_resolve {
  printf "error: %s not supported !\n",$addr;
  return 'Qmch1bQYa9zm3zvhdXZNF6LkF4DPVdCWt55qfKuAyv2nC4';
}
sub ipms_remote_mutable_resolve {
 my ($nick,$mpath) = @_;
 my $peerkey = &get_peerkey($nick);
 printf "peerkey: %s\n",$peerkey; 
 my $ipath = &mfs_remote_mutable_resolve($peerkey,$mpath);
 return $ipath;

}
sub mfs_remote_mutable_resolve { # w/ keys
 my ($key,$mpath) = @_;
 # get key@mfs:/.brings
 printf "info: name/resolve %s\n",$key;
 my $brng = &ipms_api('name/resolve',$key)->{Path};
 # extract rootdir from mpath (implicit blockrings)
 my $rootdir = $1 if ($mpath =~ m,^/([^/]+),);
 # 
 # get /.brings/mutables/brindex.log
 my $mh = &ipms_api('resolve',"$brng/mutables/brindex.log");
 my $buf = &get_hash_content($mh->{Path});
 my $list = YAML::Syck::Load($buf);
 my %table = ();
 @table{map { s,/$,,; $_ } values %$list} = (keys %$list);
 printf "table: %s\n",Dump(\%table);

 # split mutable and local path :
 # ex: michelc@ipms:/my/files/./bin/add.sh
 my ($parent,$son) = split('/\./',$mpath);
 printf "parent: %s/\n",$parent;
 printf "son: %s\n",$son;

 if (exists $table{$parent}) {
   $ipath='/ipfs/'.$table{$parent}.'/'.$son;
   printf "ipath: %s\n",$ipath
 } elsif (exists $table{'/'}) {
   $ipath='/ipfs/'.$table{'/'}.$mpath;
   printf "ipath: %s\n",$ipath
 } else {
   printf qq'error: parent "%s/" is not published\n',$parent;
   exit -$$;
 }
 my $mh = ipms_api('resolve',$ipath);
 #printf "mh: %s\n",Dump($mh);
 return $mh->{Path};


}

sub ipath_dot_search {
  my $mpath = shift;
  my $table = shift;
if (0) {
 # find the closest parent in the table...
 my @path = split('/',substr($mpath,1)); # remove leading '/'
    for my $i (reverse (0 .. $#path)) {
       my $parent = '/'.join'/',@path[0 .. $i];
       printf "parent: %s\n",$parent;
       $found++ if (exists $table{$parent});
       # check if file exist (or else continue)
       last if $i == $#path;
    }
    #$hash = ipms_api('files/stat',$parent,'&hash=1');
 }
 return -1;
}
 

sub get_peerkey {
 my $nobodykey = 'QmcEAhNT1epnXAVzuaFmvHWrQYZkxiiwipsL3W4hL1pHY9';
 my $nickname = shift;
 printf "nickname: %s\n",$nickname;
 if ($nickname eq 'self') {
   return &get_peeridkey();
 }
 my $peerids_hash = &ipms_local_mutable_resolve('mfs:/my/friends/peerids.yml');
 printf "peerids_hash: %s\n",$peerids_hash;
 #my $buf = &get_hash_content($peerids_hash);
 my $buf = &get_mutable_content('mfs:/my/friends/peerids.yml');
 
 my $peerids_table = &YAML::Syck::Load($buf);
 printf "%s.\n",Dump($peerids_table) if $dbug;
 if (exists $peerids_table->{$nickname}) {
   return $peerids_table->{$nickname};
 } else {
   return $nobodykey;
 }
}
sub get_peeridkey {
  my $key = &ipms_api('config','Identity.PeerID')->{hash};
}
sub get_mutable_content {
  my $mfs_path = shift;
     $mfs_path =~ s/^mfs://;
  my $buf = &ipms_api('files/read',$mfs_path);
  #printf "%s.\n",Dump($buf) if $dbug;
  return $buf;
}
sub get_hash_content {
  my $hash = shift;
  my $buf = &ipms_api('cat',$hash);
  #printf "%s.\n",Dump($buf) if $dbug;
  return $buf;
}

sub imps_api {
 my ($cmd,@arg) = @_;
 my $url = sprintf 'http://%s:%s/v0/api/%s?%s%s',
             $gwhost,$gwport,$cmd,@arg;
 
}

if (0) {
my %hash = ( a => 'b' );
my $hashp = \%hash;
   $hash{a};
   $hashp->{a};
}
__DATA__
set -ex

main() {
   mutable="$1";
   ipath=$(ipms_resolve $mutable);
   if [ $? -ne 0 ]; then
      echo "error: $ipath $?"
   else
      echo ipath: $ipath
   fi
}

ipms_resolve() {
   auth=${1%:*}
   mut=${1##*:}
   nick=${auth%@*}
   ns=${auth##*@}
   if [ "x$auth" = "x$mut" ]; then auth='self:mfs'; nick='self'; ns='mfs'; fi
   if [ "$nick" != 'self' ]; then
      key=$(get_peer $nick)
      ipath=$(ipms name resolve $key)
      root=${mut%%/*}
      rootkey=$(ipms resolve $ipath/logs/$root.log)
      echo rootkey: $rootkey
   fi
   exit $?;
   if [ "$nick" = 'self' ] && [ "$ns" = 'mfs' ]; then
      log info "local mfs: $mut"
      qm=$(ipms files stat --hash $mut)
      echo /ipfs/$qm
   else
      if [ "$ns" = 'ipfs' ]; then
	 if echo $mut | grep -q '/ipns/'; then
	    log info "ipns: $mut"
	    ipath=$(ipms name resolve $mut)
	 else
	    log info "ipfs: $mut"
	    ipath=$(ipms resolve $mut)
	 fi
      else
	 if [ "$ns" = 'ipms' ]; then
	    log info "ipms: $mut"
	 else
	    log info "nick: $nick; ns: $ns; $mut"
	 fi
      fi
   fi
}
log() {
  echo "$1: $2" 1>&2
}

main ${@};
exit $?;
true; # $Source: /my/shell/scripts/resolve.sh $
