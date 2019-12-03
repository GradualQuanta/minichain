#

set -e
if [ "x$1" = 'x' ]; then # usage:
echo "${0##*/} {n} {payload} [...]"
exit $$
fi

n="$1"; shift
tic=$(date +%s)
payload="$*"
# get the last block number from the toc.yml file
if [ $n \> 1 ]; then
  echo n: $n
  if p=$(expr $n - 1); then true; fi # if to mask error if p = 0
  if [ -e _includes/block$p.txt ]; then
    pn=$(ipfs add -Q _includes/block$p.txt)
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
qm=$(ipfs add -Q _includes/block$n.txt --cid-version=0)
echo qm: $qm
echo "- $qm # block $n" >> _includes/blockn.yml

