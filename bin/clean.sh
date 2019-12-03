#

bpath=/tmp/blockchaindemo

gateway=$(ipfs config Addresses.Gateway)
gwport=$(echo $gateway | cut -d/ -f 5)
gwhost=$(echo $gateway | cut -d/ -f 3)

qm=$(echo "IPFS is active" | ipfs --offline add -n -Q --hash id)
if curl -s -S -I http://$gwhost:$gwport/ipfs/$qm | grep -q X-Ipfs-Path; then
  echo "cleaning while ipfs is still running"
  ipfs files rm -rf /tmp/blockchaindemo
  ipfs files ls -l /tmp
else
  echo "cleaning IPFs repository completely"
  rm -rf _ipfs/blocks/??
  rm -rf _ipfs/datastore
  ls -l _ipfs/blocks
fi

echo "removing local copy for toc and block*"
rm -f _data/toc.yml
rm -f _includes/block[0-9].txt

