# 

installdir=_ipfs
export PATH=$installdir/bin:$PATH
export IPFS_PATH=$(pwd)/$installdir
ipfs shutdown
sleep 1
echo .
