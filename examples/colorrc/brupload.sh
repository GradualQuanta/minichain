#

# $Source: /.brings/system/bin/upload.sh$
# $Parent: /my/shell/dircolors/brpush.sh$
# $Previous: ~$
# this script uploads files to ipfs ...

list="$*"

# dependencies:
mfspath="/ipfs/QmX7v4ejhRAAgpFYYHoiJkrh23MnBSme8jh7TnyvVFdwLt/mfspath.pl"

gwhost=$(ipfs config Addresses.Gateway | cut -d'/' -f 3)
gwport=$(ipfs config Addresses.Gateway | cut -d'/' -f 5)
peerid=$(ipfs config Identity.PeerID)

if ! ipfs swarm addrs local | sed -e 's/^/info: /'; then
   die
fi



for file in $list; do
  source=$(curl -s "http://$gwhost:$gwport$mfspath" | perl /dev/stdin $file)
  source=${source##*:}
  #echo mfs: $source
  bdir=${source%/*}
  if test "x$bdir" != 'x' && ! ipfs files stat --hash $bdir 1>/dev/null 2>&1 ; then
     echo "info: !-e $bdir"
     ipfs files mkdir -p $bdir
  fi  
  if pv=$(ipfs files stat --hash $source 2>/dev/null); then
     if echo $source | grep -q '/$'; then
	  ipfs files rm -r $source
       else
	  ipfs files rm $source
       fi
  else
    pv=$(ipfs add -Q $file)
  fi
  if echo $source | grep -q '/$'; then
     cwd=$(pwd)
     bdir=${source%/*}
     qm=$(ipfs add -Q -r $cwd)
  #echo info: ips files cp /ipfs/$qm $bdir
  ipfs files cp /ipfs/$qm $bdir
  ipfs files cp /ipfs/$pv $bdir/prev
  else
  sed -i -e "s,\\\$Previous: .*\\\$,\\\$Previous: /ipfs/$pv\\\$,g" \
         -e "s,\\\$tic: .*\\\$,\\\$tic: $tic\\\$," $file
  qm=$(ipfs add -Q $file)
  ipfs files cp /ipfs/$qm $source
  fi

done

