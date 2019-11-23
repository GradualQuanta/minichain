#

export IPFS_PATH=$(pwd)/_ipfs
export PATH=$IPFS_PATH/bin:bin:$PATH
gateway=$(ipfs config Addresses.Gateway)
gwport=$(echo $gateway | cut -d/ -f 5)
gwhost=$(echo $gateway | cut -d/ -f 3)

bpath=/tmp/blockchaindemo
ipfs files rm -r $bpath

#export LC_ALL=en_US.UTF-8
payload="$*"
# set a few log variables
tic=$(date +%s)
date=$(date +%D)
peerid=$(ipfs config Identity.PeerID)
echo peerid: $peerid

if test ! -e _includes; then
  mkdir _includes
fi
if test ! -e _includes/block0.txt; then
  cat > _includes/block0.txt <<EOF
---
name: blockchain demo
block: 0 (genesis)
tic: $tic
prevhash: QmXV2wm2uWhCYPsNTUau6whiwCg4hg9CkaVjs9WnVwdLLX
payload: "$1"
...
EOF
fi
qm=$(ipfs add -Q  _includes/block0.txt)
if ipfs files mkdir $bpath 2>/dev/null; then true; fi
ipfs files cp /ipfs/$qm $bpath/block0.txt

if [ ! -e _data/toc.yml ] ; then
  cat > _data/toc.yml <<EOF
--- # blockchain demo
name: demo
owner: $peerid
peers:
 - QmRLZbRZcqdrM6L3rTFYFuz56vBoS1Z5dsu4V4X5yboZc1
 - QmcfHufAK9ErQ9ZKJF7YX68KntYYBJngkGDoVKcZEJyRve
mutable: /files/$bpath/toc.yml
irqn: $bpath/preq.yml
prev: ~
cur: ~
date: $date
spot: ~
log:
 - $qm # block genesis
EOF
fi
qm=$(ipfs add -Q  _data/toc.yml)
if ipfs files rm $bpath/toc.yml 2>/dev/null; then true; fi
ipfs files cp /ipfs/$qm $bpath/toc.yml
cur=$(ipfs files stat --hash $bpath)
sed -i -e "s,cur: .*,cur: $cur/toc.yml," _data/toc.yml
qm=$(ipfs add -Q  _data/toc.yml)
ipfs files rm $bpath/toc.yml
ipfs files cp /ipfs/$qm $bpath/toc.yml
echo url: http://127.0.0.1:${gwport}/ipfs/$(ipfs files stat --hash $bpath)


