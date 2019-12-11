#

# vim: sw=3 et ts=2

export BRNG_HOME=${BRNG_HOME:=$HOME/.brings}

if test -e ./rc.sh; then
PROJDIR=$(pwd)
echo PROJDIR: $PROJDIR
else
PROJDIR=/.brings
fi

if test -e /etc/environment; then
   . /etc/environment
else
   export PATH=/usr/local/bin:/usr/bin:/bin; 
fi
export IPFS_PATH=$BRNG_HOME/ipms
echo IPFS_PATH: $IPFS_PATH
PATH=$PROJDIR/bin:$IPFS_PATH/bin:$PATH

if test -d $BRNG_HOME/bin ; then
PATH=$PATH:$BRNG_HOME/bin;
fi

if test -d $HOME/.brings/perl5/lib/perl5; then
# perl's local lib
eval $(perl -I$HOME/.brings/perl5/lib/perl5 -Mlocal::lib=$HOME/.brings/perl5)
fi

if test -d $BRNG_HOME/etc; then
export DICT=$BRNG_HOME/etc
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
