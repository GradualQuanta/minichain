# 

# install go-ipfs ...
if test ! -x _bin/ipfs; then
  curl https://dist.ipfs.io/go-ipfs/v0.4.22/go-ipfs_v0.4.22_linux-amd64.tar.gz | tar zxfv - 
  mv go-ipfs _bin
  _bin/ipfs init
fi
_bin/ipfs config profile apply randomports
_bin/ipfs config Addresses.API /ip4/127.0.0.1/tcp/5120
_bin/ipfs config Addresses.Gateway /ip4/127.0.0.1/tcp/8199

echo test w/ daemon running
t1=$(_bin/ipfs cat /ipfs/QmejvEPop4D7YUadeGqYWmZxHhLc4JBUCzJJHWMzdcMe2y)
t2=$(_bin/ipfs cat $(echo ready | ipfs add -Q --hash ID --cid-base=base64))
echo "$t1 $t2"
_bin/ipfs cat z6CfPtYJpfWcPaEyHNpeJnVP8aKBEryY3XTh7kgLU9L6

_bin/ipfs daemon &
echo test w/ daemon running
curl http://127.0.0.1:8199/ipfs/QmejvEPop4D7YUadeGqYWmZxHhLc4JBUCzJJHWMzdcMe2y
_bin/ipfs --api=/ip4/127.0.0.1/tcp/5120 cat $(echo ready | _bin/ipfs add -Q --hash ID --cid-base=base64)
_bin/ipfs shutdown

