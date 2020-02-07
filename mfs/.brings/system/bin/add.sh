#
# $Id: $

# $Source: $
# $Date: 01/17/20$
# $Author: Michel G. Combes$
#
# $Origin: /my/shell/dircolors/upload.sh$
# $previous: QmQPWEEAjyKDqW1WNH1U1Wm3NuE3oRBBRK1UBas9KJDwUK$
# $next: ~$
# $zero: QmbcWKay5CeR64uSSKRdS6F3Spvdh7ue61xrddTg9gSMup$
#
# $tic: 1579425198$
# $spot: 1550486377$
# $Signature: ~$
#
# this script add a files to mfs ...
# all script executed remotely have their hash as "$1"
zero=${1:-~}; shift

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
  source=$(ipms cat $kwextract | perl /dev/stdin -k Source $file)
  source=${source##*:} # (remove remote host part)
  #echo mfs: $source
  bdir=${source%/*} # create parent directory if necessary
  if test "x$bdir" != 'x' && ! ipms files stat --hash $bdir 1>/dev/null 2>&1 ; then
     echo "info: !-e $bdir"
     ipms files mkdir -p $bdir
  fi  
  if pv=$(ipms files stat --hash $source 2>/dev/null); then
     if echo $source | grep -q '/$'; then # source is a folder !
	  ipms files rm -r $source
     else
	  ipms files rm $source
     fi
  else
    pv=$(ipms add -Q $file)
    
  fi
  parents=$(ipms cat $kwextract | perl /dev/stdin -k parents $file 2>/dev/null);
  if [ "x$parents" = 'x~' ]; then
  # no parents : use previous
    parents=$pv
  fi
  if echo $source | grep -q '/$'; then # source is a folder
     bdir=${source%/*}
     parentdir=${file%/*}
     if echo $parentdir | grep -q '^/'; then
	     true;
     else
        parentdir=$(pwd)
     fi
     qm=$(ipms add -Q -r $parentdir)
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
parents: "$pv" # add forces parent be previous.
previous: $pv
tic: $tic
zero: $zero
EOT
     ipms cat $kwsubsti | perl /dev/stdin /tmp/$bname.yml $file
     qm=$(ipms add -Q $file)
     ipfs_mutable_update $qm $parents $mutable
     ipms files cp /ipfs/$qm $source
     echo -n 'qm: '
     ipms files stat $source
     echo url: http://$gwhost:$gwport/ipfs/$qm
  fi
  rm -f /tmp/$bname.yml

done

}

ipfs_mutable_update(){
   qm="$1"
   parents="$2"
   file="$3"
   tmpf=/tmp/${file##*/}
   mdir=${file%/*}
   if ! ipms files stat --hash $mdir 1>/dev/null 2>&1; then
      ipms files mkdir -p $mdir
   fi
   if qmlog=$(ipms files stat --hash ${file} 2>/dev/null); then
      ipms cat /ipfs/$qmlog |\
      sed -e "s,\$parents: .*\$,\$parents: $parents\$," \
          -e "s/\$tic: .*\$/tic: $tic\$/" \
          -e "s/\$zero: .*\$/zero: $zero\$/" \
          -e "s/\$history: .*\$/history: $qmlog\$/" > $tmpf
      echo "- $qm" >> $tmpf
      history=$(ipms add -Q $tmpf --hash sha3-224 --cid-base base58btc)
      sed -i -e "s,\$history: .*\$,history: $history\$," $tmpf
      ipms files write --create  --truncate "${file}" < $tmpf
      rm -f $tmpf
   else
      genesis=z83ajSANGx6FnQqFaaELyCGFFtrxZKM3C
      # echo -n 'no history !' | ipms add --hash sha3-224 --cid-base base58btc
      history=z6CfPtEY5uJ2QozjweVm2wcwdEHGq263NA1FqCHKY6NZ
      ipms files write --create --raw-leaves "${file}" <<EOF
--- # blockRing for ${file##*/}
# \$Source: ${file}$
# \$Author: ${peerid}$
# \$previous: ${genesis}$
# \$parents: ${parents}$
# \$history: ${history}$
# \$payload: ~$
# \$zero: ${zero}$
- $qm
EOF
   history=$(ipms files read "${file}" | ipms add -Q - --hash sha3-224 --cid-base base58btc)
   fi
   echo history: $history
}

main $@
exit $?
true;
