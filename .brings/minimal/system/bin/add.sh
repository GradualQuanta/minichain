#
# $Id: $

# $Source: /.brings/system/bin/add.sh$
# $Date: 12/07/19$
# $Author: Michel G. Combes$
#
# $Previous: /ipfs/QmS7rNDrbkB9vTVERDi5C9Zm4iNqs9nGknnfCnvsNVC7c3$
# $Parent: /my/shell/dircolors/upload.sh$
#
# $tic: 2668474423$
# $spot: 2668474423$
# $Signature: ~$
#
# this script add a files to mfs ...

# dependencies:
release='QmQUBo1pderkz28hQKFwkZaNNp7JPKjJmfFoDdDT1MqUMb'
kwextract="/ipfs/$release/kwextract.pl"
kwsubsti="/ipfs/$release/kwsubsti.pl"

gwhost=$(ipfs config Addresses.Gateway | cut -d'/' -f 3)
gwport=$(ipfs config Addresses.Gateway | cut -d'/' -f 5)
peerid=$(ipfs config Identity.PeerID)

if ! ipfs swarm addrs local | sed -e 's/^/info: /'; then
   echo ipfs not running
fi


main(){

list="$*"
tic="$(date +%s)"
date="$(date +%D)"

for file in $list; do
  bname=${file##*/}
  mutable=$(ipfs cat $kwextract | perl /dev/stdin -k mutable $file)
  echo "mutable: $mutable # for $bname"

  #source=$(curl -s "http://$gwhost:$gwport$kwextract" | perl /dev/stdin $file)
  #source=$(ipfs files read /.brings/system/bin/source.pl | perl /dev/stdin $file)
  source=$(ipfs cat $kwextract | perl /dev/stdin -k source $file)
  source=${source##*:} # (remove remote host part)
  #echo mfs: $source
  bdir=${source%/*} # create parent directory if necessary
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
     echo -n 'qm: '
     ipfs files stat $bdir
  else
     cat > /tmp/$bname.yml <<EOT
name: $bname
file: $file
source: $source
date: $date
previous: $pv
tic: $tic
EOT
     ipfs cat $kwsubsti | perl /dev/stdin /tmp/$bname.yml $file
     qm=$(ipfs add -Q $file)
     ipfs_files_append "- $qm" $mutable
     ipfs files cp /ipfs/$qm $source
     echo -n 'qm: '
     ipfs files stat $source
  fi
  rm -f /tmp/$bname.yml

done

}

ipfs_files_append(){
   string="$1"
   file="$2"
   tmpf=/tmp/${file##*/}
   mdir=${file%/*}
   if ! ipfs files stat --hash $mdir 1>/dev/null 2>&1; then
      ipfs files mkdir -p $mdir
   fi
   if sz=$(ipfs files stat --format="<size>" ${file} 2>/dev/null); then
      ipfs files read "${file}" > $tmpf
      echo "$string" >> $tmpf
      ipfs files write --create  --truncate "${file}" < $tmpf
   else 
      ipfs files write --create --raw-leaves "${file}" <<EOF
--- # blockRing for ${file##*/}
# \$Source: $mutable\$
# \$Previous: z6CfPsXofAAos6rq5HX3JHxc5DtZugCY2wBjDBNnSkiA\$
- $qm
EOF
   fi

   rm -f $tmpf
}

main $@
exit $?