#


# vim: sw=3 et ts=2

if test -e /etc/environment; then
   source /etc/environment
else
   export PATH=/usr/local/bin:/usr/bin:/bin; 
fi
export IPFS_PATH=$(pwd)/_ipfs
export PATH=$(pwd)/bin:$IPFS_PATH/bin:$PATH
