# 
installdir=${BRNG_HOME:-$HOME/.brings}
export IPFS_PATH=$installdir/ipms
export PATH=$installdir/bin:$IPFS_PATH/bin:$PATH# 
ipms shutdown
sleep 1
ps ux | grep -w [i]p[fm]s
echo .

