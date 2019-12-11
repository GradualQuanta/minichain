#

export BRNG_HOME=${BRNG_HOME:=$HOME/.brings}
export IPMS_HOME=${IPMS_HOME:=$HOME/.ipms}
export IPFS_PATH=${IPFS_PATH:-$BRNG_HOME/repos}

# vim: sw=3 et ts=2
if test -e /etc/environment; then
   . /etc/environment
else
   export PATH=/usr/local/bin:/usr/bin:/bin; 
fi
# ---------------------------------------------------------------------
if test -d $IPMS_HOME/bin; then
PATH=$IPMS_HOME/bin:$PATH
fi

# update bootstrap folder (Pablo O. Haggar)
key='QmVdu2zd1B8VLn3R8xTMoD2yBVScQ1w9UMbW7CR1EJTVYw'
# ipfs name publish --key=bootstrap $(ipfs add -r -Q $PROJDIR/.brings/bootstrap)
if ipath=$(ipms --timeout 5s resolve /ipns/$key 2>/dev/null); then
 echo "ipath: $ipath"
else 
  # default to Edwin S. Hoylton
  # ipfs add -r -Q $PROJDIR/.brings/bootstrap
  ipath='/ipfs/QmeNKo4kry3LixfPGbCKsUeS1pm56gUuCo6h1edN7qhiVz'
fi
if ipms files stat --hash /.brings 1>/dev/null 2>&1; then
  if pv=$(ipms files stat --hash /.brings/bootstrap 2>/dev/null); then
    ipfs files rm -r /.brings/bootstrap
    ipms files cp $ipath /.brings/bootstrap
    if [ "${ipath#/ipfs/}" != "$pv" ]; then
      ipms files cp /ipfs/$pv /.brings/bootstrap/prev
    fi
  else
    ipms files cp $ipath /.brings/bootstrap
  fi
else
  ipms files mkdir /.brings
  ipms files cp $ipath /.brings/bootstrap
fi
echo "bootstrap: ${ipath#/ipfs/}"
# ---------------------------------------------------------------------
echo IPFS_PATH: $IPFS_PATH

if test -d $BRNG_HOME/bin ; then
PATH=$PATH:$BRNG_HOME/bin;
fi
if test -d $BRNG_HOME/etc; then
export DICT=$BRNG_HOME/etc
fi

PROJDIR=$(pwd)
echo PROJDIR: $PROJDIR
if test -d $PROJDIR/bin; then
PATH=$PROJDIR/bin:$IPFS_PATH/bin:$PATH
fi
# ---------------------------------------------------------------------
if test -d $BRNG_HOME/perl5/lib/perl5; then
# perl's local lib
eval $(perl -I$BRNG_HOME/perl5/lib/perl5 -Mlocal::lib=$BRNG_HOME/perl5)
fi

unset LC_MEASUREMENT
unset LC_PAPER
unset LC_MONETARY
unset LC_NAME
unset LC_ADDRESS
unset LC_NUMERIC
unset LC_TELEPHONE
unset LC_IDENTIFICATION
unset LC_TIME
unset LC_ALL

