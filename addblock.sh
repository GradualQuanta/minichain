#
set -e

export BRNG_HOME=${BRNG_HOME:-$HOME/.brings}
export IPMS_HOME=${IPMS_HOME:-$HOME/.ipms}
export IPFS_PATH=${IPFS_PATH:-$BRNG_HOME/ipfs}
export PATH="$IPMS_HOME/bin:$BRNG_HOME/bin:$PATH"
gateway=$(ipms --offline config Addresses.Gateway)
gwport=$(echo $gateway | cut -d/ -f 5)
gwhost=$(echo $gateway | cut -d/ -f 3)

bpath=/tmp/blockchaindemo
#export LC_ALL=en_US.UTF-8
payload="$*"
# set a few log variables
tic=$(date +%s)
date=$(date +%D)
peerid=$(ipms config Identity.PeerID)
echo peerid: $peerid

if [ ! -e _data/toc.yml ]; then
  echo "the blockchain $bpath doesn't exist"
  echo "Creating toc.yml"
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
cur: ~ # Genesis
date: $date
spot: ~
log:
...
EOF

fi

# get the last block number from the toc.yml file
n=$(cat _data/toc.yml | xyml log | wc -l)
if  [ "$n" != '0' ]; then
  n=$(expr $n - 1)
  echo n: $n
  if p=$(expr $n - 1); then true; fi # if to mask error if p = 0
  if [ -e _includes/block$p.txt ]; then
    pn=$(ipms add -Q _includes/block$p.txt)
  else
    echo pn: $pn
  fi
else
  p=0
  pn=z6cYNbecZSFzLjbSimKuibtdpGt7DAUMMt46aKQNdwfs
fi

if [ ! -e _includes/block$n.txt ]; then
if [ ! -e _includes ]; then mkdir _includes ; fi
# create the new block with the payload
cat > _includes/block$n.txt <<EOF
---
block: $n
tic: $tic
prevhash: $pn
payload: $payload
...
EOF
fi
# file block$n.txt
qm=$(ipms add -Q _includes/block$n.txt --cid-version=0)
echo qm: $qm
# save blockchain previous state:
if pv=$(ipms files stat --hash $bpath) 2>/dev/null; then
  if ipms files rm -r $bpath.prev 2>/dev/null; then true; fi # if to mask error
  ipms files mv $bpath $bpath.prev
  ipms files mkdir -p $bpath
  ipms files mv $bpath.prev $bpath/prev
else
  ipms files mkdir -p $bpath
  pv=$(ipms add -Q -w _data/toc.yml)
fi
ipms files cp /ipfs/$qm $bpath/block$n.txt

sed -i -e "s,date: .*,date: $date," \
       -e "s/owner: .*/owner: $peerid/" \
       -e "s,mutable: /ipns/[^/]*,mutable: /ipns/$peerid," \
       -e "s,prev: .*,prev: $pv/toc.yml," \
       -e "s/cur: .*/cur: ~/" \
       -e "s/\.\.\./ - $qm # block $n/" _data/toc.yml
echo "..." >> _data/toc.yml
bafy=$(ipms add -Q _data/toc.yml --cid-base base32)
if ipms files rm $bpath/toc.yml 2>/dev/null; then true; fi
ipms files cp /ipfs/$bafy $bpath/toc.yml
nv=$(ipms files stat --hash $bpath)
sed -i -e "s,cur: .*,cur: $nv/toc.yml," _data/toc.yml
bafy=$(ipms add -Q _data/toc.yml --cid-base base32)
ipms files rm $bpath/toc.yml
ipms files cp /ipfs/$bafy $bpath/toc.yml
echo url: http://127.0.0.1:${gwport}/ipfs/$(ipms files stat --hash $bpath)



