# 

export IPFS_PATH=$(pwd)/_ipfs
export PATH=_ipfs/bin:$(pwd)/bin:$PATH
# This script initialize the blockchain
#export LC_TIME='fr_FR.UTF-8'

if ! perl -Mlocal::lib=$(pwd)/_perl5 -e 1; then
  echo "perl: local::lib not found"
  echo " check if your PERL5LIB environment variable is properly set"
  echo " maybe you forgot to run . rc.sh !"
  exit $?
fi

name=minichain
# set a few log variables
tic=$(date +%s)
date=$(date +%D)
peerid=$(ipfs config Identity.PeerID)
echo peerid: $peerid
gwhost=$(ipfs config Addresses.Gateway | cut -d'/' -f 3)
gwport=$(ipfs config Addresses.Gateway | cut -d'/' -f 5)

# get a hip6 and a name
export DICT="$(pwd)/etc"
eval $(bin/hip6.pl 2>/dev/null | eyml)
eval $(fullname $peerid | eyml)
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

# make identity publicly visible
if ! ipfs files stat --hash /root/directory 1>/dev/null 2>&1; then
ipfs files mkdir -p /root/directory
else
ipfs files rm "/root/directory/$email"
fi
qm=$(ipfs files stat --hash /my/identity/public.yml)
ipfs files cp /ipfs/$qm "/root/directory/$email"

# publish root
rootkey=$(ipfs files stat --hash /root)
ipfs --offline name publish --allow-offline $rootkey 1>/dev/null &
ipfs name publish --allow-offline $rootkey 1>/dev/null
echo "url: https://gateway.ipfs.io/ipns/$peerid"
echo "url: http://$gwhost:$gwport/ipfs/$rootkey"

# bootstrap friends ...
if ! ipfs files stat --hash /my/friends 1>/dev/null 2>&1; then
ipfs files mkdir -p /my/friends
ipfs files cp /ipns/QmZV2jsMziXwrsZx5fJ6LFXDLCSyP7oUdfjXdHSLbLXxKJ /my/friends/michelc
ipfs files cp /ipns/QmVMV1xJsLH3rxmmYVEU4SZ4rjmdGBgLZF3ddbXuyKXSBy /my/friends/emilea
fi



