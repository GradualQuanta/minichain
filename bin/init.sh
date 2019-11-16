# 

export IPFS_PATH=$(pwd)/_ipfs
export PATH=_ipfs/bin:$(pwd)/bin:$PATH
# This script initialize the blockchain
export LC_TIME='fr_FR.UTF-8'

name=minichain
# set a few log variables
tic=$(date +%s)
date=$(date +%D)
peerid=$(ipfs config Identity.PeerID)
echo peerid: $peerid

# get a hip6 and a name
export DICT="$(pwd)/etc"
eval $(bin/hip6.pl 2>/dev/null | eyml)
fullname=$(fullname $peerid | xyml fullname)
uniq="${hipq:-cadavre exquis}"

# creation de profile
if false; then
echo "enter your full public name :"
read fullname
echo "enter something unique about you that people will remember :"
read uniq
fi
date=$(date)

if ! ipfs files stat -hash /my/identity/public.yml 1>/dev/null 2>&1; then
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
