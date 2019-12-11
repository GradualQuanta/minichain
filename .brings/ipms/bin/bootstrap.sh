# 

# defined ipfs ports
apiport=5122
gwport=8199

# INSTALLING IPFS ...
# -------------------

installdir=${BRNG_HOME:=$HOME/.brings}
if test ! -d $installdir; then
mkdir -p $installdir
mkdir $installdir/bin
fi
export IPFS_PATH=$installdir/ipms
export PATH=$installdir/bin:$IPFS_PATH/bin:$PATH
# install go-ipfs ...
if test ! -x $IPFS_PATH/bin/ipms; then
  curl https://dist.ipfs.io/go-ipfs/v0.4.22/go-ipfs_v0.4.22_linux-amd64.tar.gz | tar zxfv - 
  mv go-ipfs/* $IPFS_PATH/bin
  mv $installdir/bin/ipfs $installdir/bin/ipms
  ipms init
fi
ipms config profile apply randomports
ipms config Addresses.API /ip4/127.0.0.1/tcp/$apiport
ipms config Addresses.Gateway /ip4/127.0.0.1/tcp/$gwport
ipms config --json API.HTTPHeaders.Access-Control-Allow-Origin '["*"]'
ipms bootstrap add /ip4/212.129.2.151/tcp/24001/ws/ipfs/Qmd2iHMauVknbzZ7HFer7yNfStR4gLY1DSiih8kjquPzWV
ipms bootstrap list | grep 212.129.2.151

echo test w/o daemon running
t0=$(echo ready | ipms add -Q --hash ID --cid-base=base64)
t1=$(ipms cat /ipfs/QmejvEPop4D7YUadeGqYWmZxHhLc4JBUCzJJHWMzdcMe2y)
t2=$(ipms cat $t0)
echo "$t1 $t2"

ipms daemon &
sleep 7
echo test w/ daemon running
t3=$(curl -s http://127.0.0.1:$gwport/ipfs/QmejvEPop4D7YUadeGqYWmZxHhLc4JBUCzJJHWMzdcMe2y)
t4=$(ipms --api=/ip4/127.0.0.1/tcp/$apiport cat $t0)
ipms shutdown

if [ "$t0" = 'mAVUABnJlYWR5Cg' -a "$t1" = 'ipfs' -a "$t2" = 'ready' -a "$t3" = 'ipfs' -a "$t4" = 'ready' ]; then
  echo " Successful !"
fi

sleep 1
echo .

