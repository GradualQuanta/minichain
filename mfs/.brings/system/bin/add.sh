#
# $Id: $

# $Source: /.brings/files/bin/add.sh$
# $Date: 12/24/19$
# $Author: Michel G. Combes$
#
# $Parent: /my/shell/dircolors/upload.sh$
# $Previous: QmXihc28sxVvJzXXt6HwDCYtZe5v11wFA92DjdGR8BkryZ$
# $Next: ~$
#
# $tic: 1577210295$
# $spot: 2668474423$
# $Signature: ~$
#
# this script add a files to mfs ...
# all script executed remotely have their hash as "$1"
zero=shift
zero=${zero:-~}

if ! ipms swarm addrs local 1>/dev/null; then
   echo ipms not running
fi
# dependencies:
if ! release=$(ipms files stat --hash /.brings/system/bin 2>/dev/null); then
release='QmcUvbFeD59zEgV2A8hhVn3gKndLP7Sanq2xGBqnPNgJEV'
if ipms resolve /ipfs/$release; then
  ipms pin add /ipfs/$release
  if ipms files stat --hash /.brings/system/bin 1>/dev/null 2>&1; then
     ipms files rm -r /.brings/system/bin
  else
     ipms files mkdir -p /.brings/system
  fi
  ipms files cp /ipfs/$release /.brings/system/bin 
else
   echo "error: release ($release) not found"
   exit $$
fi
fi
kwextract="/ipfs/$release/kwextract.pl"
kwsubsti="/ipfs/$release/kwsubsti.pl"

#qmext=$(ipms resolve $kwextract); qmext=${qmext#/ipfs/}
#qmsub=$(ipms resolve $kwsubsti); qmsub=${qmsub#/ipfs/}

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
  if echo $source | grep -q '/$'; then # source is a folder
     bdir=${source%/*}

     parent=${file%/*}
     if echo $parent | grep -q '^/'; then
	     true;
     else
        parent=$(pwd)
     fi
     qm=$(ipms add -Q -r $parent)
     #echo info: ips files cp /ipfs/$qm $bdir
     ipms files cp /ipfs/$qm $bdir
     ipms files cp /ipfs/$pv $bdir/prev
     echo -n 'qm: '
     ipms files stat $bdir
     qm=$(ipms files stat --hash $bdir)
     echo url: http://$gwhost:$gwport/ipfs/$qm
  else
     cat > /tmp/$bname.yml <<EOT
name: $bname
file: $file
source: $source
date: $date
previous: $pv
tic: $tic
zero: $zero
EOT
     ipms cat $kwsubsti | perl /dev/stdin /tmp/$bname.yml $file
     qm=$(ipms add -Q $file)
     ipfs_files_append "- $qm" $mutable
     ipms files cp /ipfs/$qm $source
     echo -n 'qm: '
     ipms files stat $source
     echo url: http://$gwhost:$gwport/ipfs/$qm
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
      genesis=z83ajSANGx6FnQqFaaELyCGFFtrxZKM3C
      ipms files write --create --raw-leaves "${file}" <<EOF
--- # blockRing for ${file##*/}
# \$Source: ${file}$
# \$Author: ${peerid}$
# \$Previous: ${genesis}$
- $qm
EOF
   fi

   rm -f $tmpf
}

main $@
exit $?
