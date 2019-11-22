# 

# defined ipfs ports
apiport=5122
gwport=8199
if test ! -e _data; then
mkdir _data
fi
if test ! -e _data/ipfs.yml; then
cat > _data/ipfs.yml <<EOF
--- 
webui: http://127.0.0.1:$apiport
lgw: http://127.0.0.1:$gwport
EOF
fi


# INSTALLING IPFS ...
# -------------------

installdir=_ipfs
if test ! -d $installdir; then
mkdir $installdir
fi
export PATH=$installdir/bin:$PATH
export IPFS_PATH=$(pwd)/$installdir
# install go-ipfs ...
if test ! -x $installdir/bin/ipfs; then
  curl https://dist.ipfs.io/go-ipfs/v0.4.22/go-ipfs_v0.4.22_linux-amd64.tar.gz | tar zxfv - 
  mv go-ipfs/* $installdir/bin
  ipfs init
fi
ipfs config profile apply randomports
ipfs config Addresses.API /ip4/127.0.0.1/tcp/$apiport
ipfs config Addresses.Gateway /ip4/127.0.0.1/tcp/$gwport
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["*"]'

echo test w/o daemon running
t0=$(echo ready | ipfs add -Q --hash ID --cid-base=base64)
t1=$(ipfs cat /ipfs/QmejvEPop4D7YUadeGqYWmZxHhLc4JBUCzJJHWMzdcMe2y)
t2=$(ipfs cat $t0)
echo "$t1 $t2"

ipfs daemon &
sleep 7
echo test w/ daemon running
t3=$(curl -s http://127.0.0.1:$gwport/ipfs/QmejvEPop4D7YUadeGqYWmZxHhLc4JBUCzJJHWMzdcMe2y)
t4=$(ipfs --api=/ip4/127.0.0.1/tcp/$apiport cat $t0)
ipfs shutdown

if [ "$t0" = 'mAVUABnJlYWR5Cg' -a "$t1" = 'ipfs' -a "$t2" = 'ready' -a "$t3" = 'ipfs' -a "$t4" = 'ready' ]; then
  echo " Successful !"
fi

sleep 1
echo .

