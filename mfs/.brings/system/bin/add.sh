#
# $Id: $

# $Source: /.brings/files/bin/add.sh$
# $Date: 12/12/19$
# $Author: Michel G. Combes$
#
# $Previous: QmRkTN7omrUBS1YqTR1TBun8ykLJX5j72KqhjV1VxynR9U$
# $Parent: /my/shell/dircolors/upload.sh$
#
# $tic: 1576161686$
# $spot: 2668474423$
# $Signature: ~$
#
# this script add a files to mfs ...


if ! ipms swarm addrs local | sed -e 's/^/info: /'; then
   echo ipms not running
fi
# dependencies:
if ! release=$(ipms files stat --hash /.brings/system/bin 2>/dev/null); then
#release='QmQzt22HCUwHKhGZFR8PAyn2uni9TNqy9GZtkg5gpxjT6d'
release='QmcUvbFeD59zEgV2A8hhVn3gKndLP7Sanq2xGBqnPNgJEV'
fi
kwextract="/ipfs/$release/kwextract.pl"
kwsubsti="/ipfs/$release/kwsubsti.pl"

gwhost=$(ipms config Addresses.Gateway | cut -d'/' -f 3)
gwport=$(ipms config Addresses.Gateway | cut -d'/' -f 5)
peerid=$(ipms config Identity.PeerID)



main(){

list="$*"
tic="$(date +%s)"
date="$(date +%D)"

for file in $list; do
  bname=${file##*/}
  mutable=$(ipms cat $kwextract | perl /dev/stdin -k mutable $file)
  echo "mutable: $mutable # for $bname"

  #source=$(curl -s "http://$gwhost:$gwport$kwextract" | perl /dev/stdin $file)
  #source=$(ipms files read /.brings/system/bin/source.pl | perl /dev/stdin $file)
  source=$(ipms cat $kwextract | perl /dev/stdin -k source $file)
  source=${source##*:} # (remove remote host part)
  #echo mfs: $source
  bdir=${source%/*} # create parent directory if necessary
  if test "x$bdir" != 'x' && ! ipms files stat --hash $bdir 1>/dev/null 2>&1 ; then
     echo "info: !-e $bdir"
     ipms files mkdir -p $bdir
  fi  
  if pv=$(ipms files stat --hash $source 2>/dev/null); then
     if echo $source | grep -q '/$'; then
	  ipms files rm -r $source
       else
	  ipms files rm $source
       fi
  else
    pv=$(ipms add -Q $file)
  fi
  if echo $source | grep -q '/$'; then
     cwd=$(pwd)
     bdir=${source%/*}
     qm=$(ipms add -Q -r $cwd)
     #echo info: ips files cp /ipfs/$qm $bdir
     ipms files cp /ipfs/$qm $bdir
     ipms files cp /ipfs/$pv $bdir/prev
     echo -n 'qm: '
     ipms files stat $bdir
  else
     cat > /tmp/$bname.yml <<EOT
name: $bname
file: $file
source: $source
date: $date
previous: $pv
tic: $tic
EOT
     ipms cat $kwsubsti | perl /dev/stdin /tmp/$bname.yml $file
     qm=$(ipms add -Q $file)
     ipfs_files_append "- $qm" $mutable
     ipms files cp /ipfs/$qm $source
     echo -n 'qm: '
     ipms files stat $source
  fi
  rm -f /tmp/$bname.yml

done

}

ipfs_files_append(){
   string="$1"
   file="$2"
   tmpf=/tmp/${file##*/}
   mdir=${file%/*}
   if ! ipms files stat --hash $mdir 1>/dev/null 2>&1; then
      ipms files mkdir -p $mdir
   fi
   if sz=$(ipms files stat --format="<size>" ${file} 2>/dev/null); then
      ipms files read "${file}" > $tmpf
      echo "$string" >> $tmpf
      ipms files write --create  --truncate "${file}" < $tmpf
   else 
      ipms files write --create --raw-leaves "${file}" <<EOF
--- # blockRing for ${file##*/}
# \$Source: /.brings/files/bin/add.sh$
# \$Previous: QmRkTN7omrUBS1YqTR1TBun8ykLJX5j72KqhjV1VxynR9U$
- $qm
EOF
   fi

   rm -f $tmpf
}

main $@
exit $?
