# 

OPTION='--unrestricted-api --enable-namesys-pubsub'
export IPMS_HOME=${IPMS_HOME:-$HOME/.ipms}
export IPFS_PATH=${IPFS_PATH:-$HOME/.brings/ipfs}
export PATH="$IPMS_HOME/bin:$PATH"

gateway=$(ipms --offline config Addresses.Gateway)
gwport=$(echo $gateway | cut -d/ -f 5)
gwhost=$(echo $gateway | cut -d/ -f 3)

# test if daemon already running:
qm=$(echo "IPFS is active" | ipms --offline add -n -Q --hash id)
if curl -s -S -I http://$gwhost:$gwport/ipfs/$qm | grep -q X-Ipfs-Path 2>/dev/null; then
 ipms swarm addrs local
else 
ipms daemon $OPTION &
sleep 1
echo .
fi

