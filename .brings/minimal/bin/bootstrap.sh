#
if [ "$0" = "/dev/stdin" ]; then
# ----------------------------------------------------------------
# update $symb folder for others ... (Jose S. Furutani)
 symb='minimal'
 key='QmVQd43Y5DQutAbgqiQkZtKJNd8mJiZr9Eq8D7ac2PeSL1'
 qm='Qmf36X5Npn6sEK2BcWqr4waWUZYMHfSn2tCENRX5t1ZtyH'
if ipath=$(ipms --timeout 5s resolve /ipns/$key 2>/dev/null); then
 echo "$symb: $ipath # (global)"
else
  # default to ...
  ipath="/ipfs/$qm"
  echo "$symb: ${qm} # (default)"
fi
if ipms files stat --hash /.brings 1>/dev/null 2>&1; then
  if pv=$(ipms files stat --hash /.brings/$symb 2>/dev/null); then
    ipms files mv /.brings/$symb /.brings/${symb}~
    if ipms files rm -r /.brings/${symb}~/prev 2>/dev/null; then true; fi
    npv=$(ipms files stat --hash /.brings/${symb}~) # w/o prev
    ipms files rm -r /.brings/${symb}~
    ipms files cp $ipath /.brings/$symb
    if ipms files rm -r /.brings/$symb/prev 2>/dev/null; then true; fi
    nqm=$(ipms files stat --hash /.brings/${symb}) # w/o prev
    if [ "$nqm" != "$npv" ]; then 
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
else
 echo "no bootstrap allowed unless remotely ..."
fi
exit $?
