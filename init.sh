# 

# This script initialize the blockchain
# $Source: /root/demo/bin/init.sh$

yellow="[33m"
red="[31m"
nc="[0m"

name=minichain

export BRNG_HOME=${BRING_HOME:=$HOME/.brings}

if test -e ./envrc.sh; then
PROJDIR=$(pwd)
export IPFS_PATH=$BRNG_HOME/ipms
export PATH=$BRNG_HOME/bin:$IPFS_PATH/bin:$PATH

sed -e "s|^PROJDIR=/.brings$|PROJDIR=$PROJDIR|" envrc.sh > $BRNG_HOME/envrc.sh
fi

. $BRNG_HOME/envrc.sh

if ! perl -Mlocal::lib=$HOME/.brings/perl5 -e 1; then
  echo "perl: local::lib not found"
  echo " ${yellow}check if your PERL5LIB environment variable is properly set${nc}"
  echo " ${red}maybe you forgot to run . envrc.sh !${nc}"
  exit $?
fi

# set a few log variables
tic=$(date +%s)
date=$(date +%D)
peerid=$(ipms config Identity.PeerID)
echo peerid: $peerid
gwhost=$(ipms config Addresses.Gateway | cut -d'/' -f 3)
gwport=$(ipms config Addresses.Gateway | cut -d'/' -f 5)

exit
# get an hip6 and a name
export DICT="$BRNG_HOME/etc"
eval $(hip6 2>/dev/null | eyml)
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

if ! ipms files stat --hash /my/identity/public.yml 1>/dev/null 2>&1; then
ipms files mkdir -p /my/identity
ipms files write --create --truncate /my/identity/public.yml <<EOF
--- # This is my blockRing™ Sovereign identity
name: "$fullname"
uniq: "$uniq"
date: $date
exp: never
hip6: $hip6
attr: QmbFMke1KXqnYyBBWxB74N4c5SBnJMVAiMNRcGu6x1AwQH
EOF
fi
ipms files read /my/identity/public.yml

ipms files mkdir -p /etc
ipms files write --create --truncate /etc/motd <<EOF
Date: $date
Welcome to $name demo

$fullname will be your *bot, managing the blockchain.

--
EOF
if ipms key list -l | grep -q -w etc; then
  key=$(ipms key list -l | grep -w etc | cut -d' ' -f 1)
else
  key=$(ipms key gen -t rsa -s 3072 etc)
fi


# /root/directory
if ! ipms files stat --hash /root/directory 1>/dev/null 2>&1; then
ipms files mkdir -p /root/directory
else
ipms files rm -r "/root/directory/$email"
fi
qm=$(ipms files stat --hash /my/identity/public.yml)
ipms files cp /ipfs/$qm "/root/directory/$email"
if ipms key list -l | grep -q -w root; then
  key=$(ipms key list -l | grep -w root | cut -d' ' -f 1)
else
  key=$(ipms key gen -t rsa -s 3072 root)
fi


# /public
if ! ipms files stat --hash /public 1>/dev/null 2>&1; then
ipms files mkdir -p /public
fi
if ipms key list -l | grep -q -w public; then
  key=$(ipms key list -l | grep -w public | cut -d' ' -f 1)
else
  key=$(ipms key gen -t rsa -s 3072 public)
fi

# /.brings
if ! ipms files stat --hash /.brings 1>/dev/null 2>&1; then
ipms files mkdir -p /.brings
fi
if ipms key list -l | grep -q -w brings; then
  key=$(ipms key list -l | grep -w brings | cut -d' ' -f 1)
else
  key=$(ipms key gen -t rsa -s 3072 brings)
fi

if ! ipms files stat --hash /my 1>/dev/null 2>&1; then
ipms files mkdir -p /my
fi

# publish /.brings
brkey=$(ipms files stat --hash /.brings)
ipms --offline name publish --key=brings --allow-offline $brkey 1>/dev/null &
ipms name publish --allow-offline $brkey 1>/dev/null
echo "url: https://gateway.ipfs.io/ipns/$peerid"
echo "url: http://$gwhost:$gwport/ipfs/$brkey"

# bootstrap /my/friends ...
if ! ipms files stat --hash /my/friends 1>/dev/null 2>&1; then
ipms files mkdir -p /my/friends
ipms files cp /ipns/QmZV2jsMziXwrsZx5fJ6LFXDLCSyP7oUdfjXdHSLbLXxKJ /my/friends/michelc
fi

if ipms key list -l | grep -q -w my; then
  key=$(ipms key list -l | grep -w my | cut -d' ' -f 1)
else
  key=$(ipms key gen -t rsa -s 3072 my)
fi

ipms key list -l


