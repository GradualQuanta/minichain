# 

# INSTALLING IPFS ...
# -------------------
ver='v0.4.22';

export IPFS_PATH=${IPFS_PATH:-$HOME/.ipms}
if test ! -d $IPFS_PATH; then
mkdir -p $IPFS_PATH
fi
export IPMS_HOME=${IPMS_HOME:-$HOME/.brings/ipms}
if test ! -d $IPMS_HOME/bin; then
mkdir -p $IPMS_HOME/bin
fi

export PATH=$IPMS_HOME/bin:$PATH
# install go-ipfs ...
if test ! -x $IPMS_HOME/bin/ipms; then
  if test ! -e $IPMS_HOME/go-ipfs_${ver}_linux-amd64.tar.gz; then
    curl https://dist.ipfs.io/go-ipfs/${ver}/go-ipfs_${ver}_linux-amd64.tar.gz -o $IPMS_HOME/go-ipfs_${ver}_linux-amd64.tar.gz;
  fi
  tar zxfv $IPMS_HOME/go-ipfs_${ver}_linux-amd64.tar.gz
  mv go-ipfs/* $IPMS_HOME/bin
  mv $IPMS_HOME/bin/ipfs $IPMS_HOME/bin/ipms
  rmdir go-ipfs
fi
if test ! -e $IPFS_PATH/config; then
  # defined ipfs ports
  apiport=5122
  gwport=8199
  ipms init
  ipms config Addresses.API /ip4/127.0.0.1/tcp/$apiport
  ipms config Addresses.Gateway /ip4/127.0.0.1/tcp/$gwport
  ipms config profile apply randomports
else
  apiport=$(ipms config Addresses.API | cut -d'/' -f 5)
  gwport=$(ipms config Addresses.Gateway | cut -d'/' -f 5)
fi
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

# ----------------------------------------------------------------
# update bootstrap folder (Pablo O. Haggar)
key='QmVdu2zd1B8VLn3R8xTMoD2yBVScQ1w9UMbW7CR1EJTVYw'
# ipfs name publish --key=bootstrap $(ipfs add -r -Q $PROJDIR/.brings/bootstrap)
if ipath=$(ipms --timeout 5s resolve /ipns/$key 2>/dev/null); then
 echo "ipath: $ipath"
else
  # default to Cheryl M. Dewiel
  # ipfs add -r -Q $PROJDIR/.brings/bootstrap
  ipath='/ipfs/QmYSTrLraVaMUGwaCpGYNw4hpt9JYXnYMDCiVv2FJfGorP'
fi
if ipms files stat --hash /.brings 1>/dev/null 2>&1; then
  if pv=$(ipms files stat --hash /.brings/bootstrap 2>/dev/null); then
    ipfs files rm -r /.brings/bootstrap
    ipms files cp $ipath /.brings/bootstrap
    if [ "${ipath#/ipfs/}" != "$pv" ]; then
      ipms files cp /ipfs/$pv /.brings/bootstrap/prev
    fi
  else
    ipms files cp $ipath /.brings/bootstrap
  fi
else
  ipms files mkdir /.brings
  ipms files cp $ipath /.brings/bootstrap
fi
echo "bootstrap: ${ipath#/ipfs/}"
# ----------------------------------------------------------------

ipms shutdown

if [ "$t0" = 'mAVUABnJlYWR5Cg' -a "$t1" = 'ipfs' -a "$t2" = 'ready' -a "$t3" = 'ipfs' -a "$t4" = 'ready' ]; then
  echo " Successful !"
fi

sleep 1
echo .

