# 

set -e
# INSTALLING IPFS ...
# -------------------
ver='v0.4.22';
echo "${0##*/}: installing IPFS $ver"
export IPFS_PATH=${IPFS_PATH:-$HOME/.brings/ipfs}
if test ! -d $IPFS_PATH; then
mkdir -p $IPFS_PATH
fi
echo IPFS_PATH: ${IPFS_PATH}

export IPMS_HOME=${IPMS_HOME:-$HOME/.brings/ipms}
if test ! -d $IPMS_HOME/bin; then
mkdir -p $IPMS_HOME/bin
else
if test -e $IPFS_PATH/api; then
 if $IPMS_HOME/bin/ipms --timeout 5s shutdown; then true; fi
fi
fi

export PATH="$IPMS_HOME/bin:$PATH"
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
if test -e $IPFS_PATH/api; then
rm $IPFS_PATH/api
fi
if test ! -e $IPFS_PATH/config; then
  # defined ipms ports
  apiport=5122
  gwport=8199
  ipms init
  ipms config Addresses.API /ip4/127.0.0.1/tcp/$apiport
  ipms config Addresses.Gateway /ip4/0.0.0.0/tcp/$gwport
  ipms config profile apply randomports
else
  apiport=$(ipms config Addresses.API | cut -d'/' -f 5)
  gwport=$(ipms  config Addresses.Gateway | cut -d'/' -f 5)
fi
ipms config --json API.HTTPHeaders.Access-Control-Allow-Origin '["*"]'
ipms bootstrap add /ip4/212.129.2.151/tcp/24001/ws/ipfs/Qmd2iHMauVknbzZ7HFer7yNfStR4gLY1DSiih8kjquPzWV
ipms bootstrap list | grep 212.129.2.151


# define colors
red="[31m"; yellow="[33m"; green="[32m"; nc="[0m"
line=$(echo ----------------------------------------------------------------------- | ipms --offline add -Q)
ipms cat $line
echo test w/o daemon running
t0=$(echo ready | ipms --offline add -Q --hash ID --cid-base=base64)
t1=$(ipms cat /ipfs/QmejvEPop4D7YUadeGqYWmZxHhLc4JBUCzJJHWMzdcMe2y)
t2=$(ipms cat $t0)
echo "${yellow}$t1 $t2${nc}"
ipms cat $line
ipms daemon &
sleep 7
ipms cat $line

echo /ip4/127.0.0.1/tcp/$apiport > $IPFS_PATH/api
echo test w/ daemon running

set -x
t3=$(curl -s http://127.0.0.1:$gwport/ipfs/QmW58ZW9dMkGs4oFcYkDJdYftmsoh4aR7j26b2sFBnVFFj)
t4=$(ipms --api=/ip4/127.0.0.1/tcp/$apiport cat $t0)
echo "${green}$t3 $t4${nc}"

ipms cat $line
echo shutting down daemon
ipms shutdown

sleep 7
ipms --offline cat $line
if [ "$t0" = 'mAVUABnJlYWR5Cg' -a "$t1" = 'ipfs' -a "$t2" = 'ready' -a "$t3" = 'ipms' -a "$t4" = 'ready' ]; then
  echo " ${green}Successful${nc} !"
else
  echo " ${red}Failed${nc} !"
fi

echo .

