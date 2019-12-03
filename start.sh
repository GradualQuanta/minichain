# 

installdir=_ipfs
export PATH=$installdir/bin:$PATH
export IPFS_PATH=$(pwd)/$installdir

gateway=$(ipfs config Addresses.Gateway)
gwport=$(echo $gateway | cut -d/ -f 5)
gwhost=$(echo $gateway | cut -d/ -f 3)

# test if daemon already running:
qm=$(echo "IPFS is active" | ipfs add -n -Q --hash id)
if curl -s -S -I http://$gwhost:$gwport/ipfs/$qm | grep -q X-Ipfs-Path; then
 ipfs swarm addrs local
else 
ipfs daemon &
sleep 1
echo .
fi

