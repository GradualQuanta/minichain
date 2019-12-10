#

green="[32m"
yellow="[33m"
red="[31m"
nc="[0m"

#qm=$(echo "IPFS is active" | ipfs add --offline -Q) && echo "qm: $qm"

export IPFS_PATH=${IPFS_PATH:=$HOME/.ipfs}
if ! ipfs swarm addrs local 2>/dev/null; then
  echo "${red}WARNING no ipfs daemon running${nc}"
  OPTIONS="--unrestricted-api --enable-namesys-pubsub"
  pp=$(cat $IPFS_PATH/config | xjson Addresses.Gateway | cut -d'/' -f 5)
  name=$(cat $IPFS_PATH/config | xjson Identity.PeerID | fullname)

  if which irxvt 1>/dev/null; then
    rxvt -geometry 128x18 -bg black -fg orange -name IPFS -n "$pp" -title "ipfs daemon:$pp ($IPFS_PATH) ~ $name" -e ipfs daemon $OPTIONS &
  else
    gnome-terminal --title "ipfs daemon:$pp ($IPFS_PATH) ~ $name" -- ipfs daemon $OPTIONS &
  fi

else
  echo "${green}ipfs daemon is already running${nc}"
fi



