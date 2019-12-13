# 

OPTION='--unrestricted-api --enable-namesys-pubsub'
export IPMS_HOME=${IPMS_HOME:-$HOME/.ipms}
export IPFS_PATH=${IPFS_PATH:-$HOME/.brings/ipfs}
export PATH="$IPMS_HOME/bin:$PATH"

peerid=$(ipms --offline config Identity.PeerID)
gateway=$(ipms --offline config Addresses.Gateway)
gwport=$(echo $gateway | cut -d/ -f 5)
gwhost=$(echo $gateway | cut -d/ -f 3)

# test if daemon already running:
qm=$(echo "IPFS is active" | ipms --offline add -n -Q --hash id)
if curl -s -S -I http://$gwhost:$gwport/ipfs/$qm | grep -q X-Ipfs-Path 2>/dev/null; then
 echo local addrs:
 ipms swarm addrs local
else 
nohup ipms daemon $OPTION &
sleep 7
fi
# ping a few friends :)
blockring=Qmd2iHMauVknbzZ7HFer7yNfStR4gLY1DSiih8kjquPzWV; ipms ping -n 1 $blockring 1>/dev/null

michelc=QmcfHufAK9ErQ9ZKJF7YX68KntYYBJngkGDoVKcZEJyRve; ipms ping -n 1 $michelc 1>/dev/null 2>&1
ipms ping -n 1 QmZV2jsMziXwrsZx5fJ6LFXDLCSyP7oUdfjXdHSLbLXxKJ 1>/dev/null
ipms ping -n 1 QmRLZbRZcqdrM6L3rTFYFuz56vBoS1Z5dsu4V4X5yboZc1 1>/dev/null 2>&1
ipms ping -n 1 QmcfHufAK9ErQ9ZKJF7YX68KntYYBJngkGDoVKcZEJyRve 1>/dev/null 2>&1

# resolve a few names ahead of time ( /!\ take 1min per resolution ... )
ipms name resolve $blockring 1>/dev/null & 
ipms name resolve QmVQd43Y5DQutAbgqiQkZtKJNd8mJiZr9Eq8D7ac2PeSL1 1>/dev/null & 
#ipms name resolve QmNcpA2jL4QCmMinH65W23TbMLm4oQTsrwRSmzMSk9KbNm
echo .

