#

export IPFS_PATH=$(pwd)/_ipfs
export PATH=$IPFS_PATH/bin:bin:$PATH
gateway=$(ipfs config Addresses.Gateway)
gwport=$(echo $gateway | cut -d/ -f 5)
gwhost=$(echo $gateway | cut -d/ -f 3)

bpath=/tmp/blockchaindemo
#export LC_ALL=en_US.UTF-8
payload="$*"
# set a few log variables
tic=$(date +%s)
date=$(date +%D)
peerid=$(ipfs config Identity.PeerID)
echo peerid: $peerid

# get the last block number from the toc.yml file
n=$(cat _data/toc.yml | xyml log | wc -l)
if  [ "$n" != '0' ]; then
n=$(expr $n - 1)
echo n: $n
p=$(expr $n - 1)
if [ -e _includes/block$p.txt ]; then
pn=$(ipfs add -Q _includes/block$p.txt)
else
pn=z6cYNbecZSFzLjbSimKuibtdpGt7DAUMMt46aKQNdwfs
fi
else
p=0
pn=z6cYNbecZSFzLjbSimKuibtdpGt7DAUMMt46aKQNdwfs
fi

if [ ! -e _includes/block$n.txt ]; then
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
qm=$(ipfs add -Q _includes/block$n.txt --cid-version=0)
# save blockchain previous state:
pv=$(ipfs files stat --hash $bpath)
if [ "x$pv" = 'x' ]; then
   ipfs files mkdir -p $bpath
   pv=$(ipfs files stat --hash $bpath)
fi
ipfs files rm -r $bpath.prev 2>/dev/null
ipfs files mv $bpath $bpath.prev
ipfs files mkdir $bpath
ipfs files mv $bpath.prev $bpath/prev
ipfs files cp /ipfs/$qm $bpath/block$n.txt

sed -i -e "s,date: .*,date: $date," \
       -e "s/owner: .*/owner: $peerid/" \
       -e "s,mutable: /ipns/[^/]*,mutable: /ipns/$peerid," \
       -e "s,prev: .*,prev: $pv/toc.yml," \
       -e "s/cur: .*/cur: ~/" \
       -e "s/\.\.\./ - $qm # block $n/" _data/toc.yml
echo "..." >> toc.yml
bafy=$(ipfs add -Q _data/toc.yml --cid-base base32)
ipfs files rm $bpath/toc.yml
ipfs files cp /ipfs/$bafy $bpath/toc.yml
nv=$(ipfs files stat --hash $bpath)
sed -i -e "s,cur: .*,cur: $nv/toc.yml," toc.yml
bafy=$(ipfs add -Q _data/toc.yml --cid-base base32)
ipfs files rm $bpath/toc.yml
ipfs files cp /ipfs/$bafy $bpath/toc.yml
echo url: http://127.0.0.1:${gwport}/ipfs/$(ipfs files stat --hash $bpath)



