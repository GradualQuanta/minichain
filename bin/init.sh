# 

yellow="[33m"
red="[31m"
nc="[0m"

name=minichain

idir=$(pwd)
export IPFS_PATH=$(pwd)/_ipfs
export PATH=_ipfs/bin:$(pwd)/bin:$PATH

# This script initialize the blockchain
sed -i -e "s|^idir=.*$|idir=$idir|" rc.sh

. ./rc.sh

if ! perl -Mlocal::lib=$(pwd)/_perl5 -e 1; then
  echo "perl: local::lib not found"
  echo " ${yellow}check if your PERL5LIB environment variable is properly set${nc}"
  echo " ${red}maybe you forgot to run . rc.sh !${nc}"
  exit $?
fi

# set a few log variables
tic=$(date +%s)
date=$(date +%D)
peerid=$(ipfs config Identity.PeerID)
echo peerid: $peerid
gwhost=$(ipfs config Addresses.Gateway | cut -d'/' -f 3)
gwport=$(ipfs config Addresses.Gateway | cut -d'/' -f 5)

exit
# get an hip6 and a name
export DICT="$(pwd)/etc"
eval $(bin/hip6.pl 2>/dev/null | eyml)
eval $(fullname -a $peerid | eyml)
uniq="${hipq:-cadavre exquis}"

# creation de profile
if false; then
echo "enter your full public name :"
read fullname
echo "enter something unique about you that people will remember :"
read uniq
fi
date=$(date)

if ! ipfs files stat --hash /my/identity/public.yml 1>/dev/null 2>&1; then
ipfs files mkdir -p /my/identity
ipfs files write --create --truncate /my/identity/public.yml <<EOF
--- # This is my blockRing™ Sovereign identity
name: "$fullname"
uniq: "$uniq"
date: $date
exp: never
hip6: $hip6
attr: QmbFMke1KXqnYyBBWxB74N4c5SBnJMVAiMNRcGu6x1AwQH
EOF
fi
ipfs files read /my/identity/public.yml

ipfs files mkdir -p /etc
ipfs files write --create --truncate /etc/motd <<EOF
Date: $date
Welcome to $name demo

$fullname will be your *bot, managing the blockchain.

--
EOF
if ipfs key list -l | grep -q -w etc; then
  key=$(ipfs key list -l | grep -w etc | cut -d' ' -f 1)
else
  key=$(ipfs key gen -t rsa -s 3072 etc)
fi


# /root/directory
if ! ipfs files stat --hash /root/directory 1>/dev/null 2>&1; then
ipfs files mkdir -p /root/directory
else
ipfs files rm -r "/root/directory/$email"
fi
qm=$(ipfs files stat --hash /my/identity/public.yml)
ipfs files cp /ipfs/$qm "/root/directory/$email"
if ipfs key list -l | grep -q -w root; then
  key=$(ipfs key list -l | grep -w root | cut -d' ' -f 1)
else
  key=$(ipfs key gen -t rsa -s 3072 root)
fi


# /public
if ! ipfs files stat --hash /public 1>/dev/null 2>&1; then
ipfs files mkdir -p /public
fi
if ipfs key list -l | grep -q -w public; then
  key=$(ipfs key list -l | grep -w public | cut -d' ' -f 1)
else
  key=$(ipfs key gen -t rsa -s 3072 public)
fi

# /.brings
if ! ipfs files stat --hash /.brings 1>/dev/null 2>&1; then
ipfs files mkdir -p /.brings
fi
if ipfs key list -l | grep -q -w brings; then
  key=$(ipfs key list -l | grep -w brings | cut -d' ' -f 1)
else
  key=$(ipfs key gen -t rsa -s 3072 brings)
fi

if ! ipfs files stat --hash /my 1>/dev/null 2>&1; then
ipfs files mkdir -p /my
fi

# publish /.brings
brkey=$(ipfs files stat --hash /.brings)
ipfs --offline name publish --key=brings --allow-offline $brkey 1>/dev/null &
ipfs name publish --allow-offline $brkey 1>/dev/null
echo "url: https://gateway.ipfs.io/ipns/$peerid"
echo "url: http://$gwhost:$gwport/ipfs/$brkey"

# bootstrap /my/friends ...
if ! ipfs files stat --hash /my/friends 1>/dev/null 2>&1; then
ipfs files mkdir -p /my/friends
ipfs files cp /ipns/QmZV2jsMziXwrsZx5fJ6LFXDLCSyP7oUdfjXdHSLbLXxKJ /my/friends/michelc
fi

if ipfs key list -l | grep -q -w my; then
  key=$(ipfs key list -l | grep -w my | cut -d' ' -f 1)
else
  key=$(ipfs key gen -t rsa -s 3072 my)
fi

ipfs key list -l



