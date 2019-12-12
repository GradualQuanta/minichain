#
if echo "$0" | grep -q '^/'; then
  rootdir="${0%/bin/*}"
else
  rootdir="$(pwd)"; rootdir="${rootdir%/bin}"
fi
symb="${rootdir##*/}"
# --------------------------------------------------------------
qm=$(ipms add -r -Q .)
if ipms files stat --hash /.brings/$symb/bin 1>/dev/null; then
 ipms files rm -r /.brings/$symb/bin
else
  ipms files mkdir -p /.brings/$symb
fi
ipms files cp /ipfs/$qm /.brings/$symb/bin
echo -n 'bin: '
ipms files stat /.brings/$symb/bin
# --------------------------------------------------------------
if ipms key list | grep -q -w $symb; then
 key=$(ipms key list -l | grep -w $symb | cut -d' ' -f 1)
 echo key: $key
   sed -i -e "s/symb='.*'$/symb='$symb'/" \
          -e "s/key='.*'$/key='$key'/" install.sh # $'s are important

   qm=$(ipms files stat --hash /.brings/$symb) # only . updated
   ipfs name publish --allow-offline --key=$symb /ipfs/$qm
else
 if test -d $rootdir; then
   qm=$(ipfs add -r -Q $rootdir)
   sed -i -e "s/qm='.*'$/qm='$qm'/" \
          -e "s,ipath='/ipfs/.*'$,ipath='/ipfs/$qm'," install.sh
 fi
fi
echo $symb: $qm
# --------------------------------------------------------------
exit $?



