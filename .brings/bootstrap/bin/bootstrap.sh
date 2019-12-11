#
set -e
if echo "$0" | grep -q '^/'; then
  rootdir="${0%/bin/*}"
else
  rootdir="$(pwd)"; rootdir="${rootdir%/bin}"
fi
symb="${rootdir##*/}"
if ipms key list | grep -q -w $symb; then
 key=$(ipms key list -l | grep -w $symb | cut -d' ' -f 1)
 echo key: $key
 if test -d $rootdir; then
   qm=$(ipfs add -r -Q $rootdir)
   sed -i -e "s/qm='.*'$/qm='$qm'/" \
          -e "s,ipath='/ipfs/.*'$,ipath='/ipfs/$qm'," \
          -e "s/key='.*'$/key='$key'/" $0 # $'s are important /!\
   ipfs name publish --allow-offline --key=$symb /ipfs/$qm
 fi
else # for others ...
 key='QmVdu2zd1B8VLn3R8xTMoD2yBVScQ1w9UMbW7CR1EJTVYw'
 qm='QmVEwqUqoS6CkoEafHtmduUp1gsMGbsyY6fy1mtNwHVddS'
fi
# ----------------------------------------------------------------
# update $symb folder (Pablo O. Haggar)
if ipath=$(ipms --timeout 5s resolve /ipns/$key 2>/dev/null); then
 echo "$symb: $ipath # (global)"
else
  # default to Elvis C. Lagoo
  # ipfs add -r -Q $PROJDIR/.brings/$symb
  if [ "x$qm" = 'x' ]; then
  ipath='/ipfs/QmVEwqUqoS6CkoEafHtmduUp1gsMGbsyY6fy1mtNwHVddS'
  else 
  ipath="/ipfs/$qm"
  fi
  echo "$symb: ${ipath#/ipfs/}"
fi
if ipms files stat --hash /.brings 1>/dev/null 2>&1; then
  if pv=$(ipms files stat --hash /.brings/$symb 2>/dev/null); then
    ipms files rm -r /.brings/$symb
    ipms files cp $ipath /.brings/$symb
    if [ "${ipath#/ipfs/}" != "$pv" ]; then
      if ipms files rm -r /.brings/$symb/prev 2>/dev/null; then true; fi
      ipms files cp /ipfs/$pv /.brings/$symb/prev
      ipath=/ipfs/$(ipms files stat --hash /.brings/$symb)
      echo "$symb: ${ipath#/ipfs/} # (new)"
    fi
  else
    ipms files cp $ipath /.brings/$symb
  fi
else
  ipms files mkdir /.brings
  ipms files cp $ipath /.brings/$symb
fi
# ---------------------------------------------------------------------

