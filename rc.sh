#


# vim: sw=3 et ts=2

cwd=$(pwd)

if test -e /etc/environment; then
   source /etc/environment
else
   export PATH=/usr/local/bin:/usr/bin:/bin; 
fi
export IPFS_PATH=${cwd}/_ipfs
export PATH=${cwd}/bin:$IPFS_PATH/bin:$PATH

# perl's local lib
[ $SHLVL -eq 1 ] && eval $(perl -I$cwd/_perl5/lib/perl5 -Mlocal::lib=$cwd/_perl5)


export DICT=${cwd}/etc

export LC_TIME=en_US.UTF-8
