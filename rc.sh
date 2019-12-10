#


# vim: sw=3 et ts=2

if test -e ./rc.sh; then
idir=$(pwd)
echo idir: $idir
else
idir=/.brings
fi

if test -e /etc/environment; then
   . /etc/environment
else
   export PATH=/usr/local/bin:/usr/bin:/bin; 
fi
export IPFS_PATH=${idir}/_ipfs
export PATH=${idir}/bin:$IPFS_PATH/bin:$PATH

if test -d $idir/_perl5/lib/perl5; then
# perl's local lib
eval $(perl -I$idir/_perl5/lib/perl5 -Mlocal::lib=$idir/_perl5)
fi

if test -d $idir/etc; then
export DICT=${idir}/etc
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
