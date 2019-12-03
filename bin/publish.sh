# 

# this script publish the hash of /root to the peerid

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

if ! ipfs files stat --hash /root/directory 1>/dev/null 2>&1; then
ipfs files mkdir -p /root/directory
else
ipfs files rm "/root/directory/$email"
fi
peerid=$(ipfs config Identity.PeerID)
eval "$(fullname -a $peerid | eyml)"
qm=$(ipfs files stat --hash /my/identity/public.yml)
ipfs files cp /ipfs/$qm "/root/directory/$email"

rootkey=$(ipfs files stat --hash /root)
ipfs name publish --allow-offline $rootkey



if ! ipfs files stat --hash /my/friends 1>/dev/null 2>&1; then
ipfs files mkdir -p /my/friends
ipfs files cp /ipns/QmZV2jsMziXwrsZx5fJ6LFXDLCSyP7oUdfjXdHSLbLXxKJ /my/friends/michelc
ipfs file cp /ipns/QmVMV1xJsLH3rxmmYVEU4SZ4rjmdGBgLZF3ddbXuyKXSBy /my/friends/emilea
fi


