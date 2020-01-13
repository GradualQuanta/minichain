#

export BRNG_HOME=${BRNG_HOME:-$HOME/.brings}
export IPMS_HOME=${IPMS_HOME:-$HOME/.ipms}
export IPFS_PATH=${IPFS_PATH:-$BRNG_HOME/ipfs}

# vim: sw=3 et ts=2
if test -e /etc/environment; then
   . /etc/environment
else
   export PATH=/usr/local/bin:/usr/bin:/bin; 
fi
# ---------------------------------------------------------------------
echo IPFS_PATH: $IPFS_PATH

if test -d $IPMS_HOME/bin ; then
PATH="$IPMS_HOME/bin:$PATH"
fi
if test -d $BRNG_HOME/bin ; then
PATH="$BRNG_HOME/bin:$PATH"
fi
if test -d $BRNG_HOME/etc; then
export DICT="$BRNG_HOME/etc"
fi
# ---------------------------------------------------------------------
# perl's local lib
if [ "x$PERL5LIB" != 'x' ]; then
eval $(perl -I$PERL5LIB -Mlocal::lib=${PERL5LIB%/lib/perl5})
else
if test -d $BRNG_HOME/perl5/lib/perl5; then
eval $(perl -I$BRNG_HOME/perl5/lib/perl5 -Mlocal::lib=$BRNG_HOME/perl5)
fi
fi
# ---------------------------------------------------------------------

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

