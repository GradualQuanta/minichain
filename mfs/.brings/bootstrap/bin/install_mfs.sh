# 

MFS_SRC=${MFS_SRC:-$(pwd)/mfs}
if [ -d $MFS_SRC ]; then
echo mfs: $MFS_SRC
qm=$(ipms add -Q -r $MFS_SRC/.brings)
else
qm='QmcSsSV9z16ynPWp4W7o4JTbztQV49hFVPU5Uktic9Swad'
fi
if ipms files stat --hash /.brings 1>/dev/null; then
  ipms files rm -r /.brings
fi
if ipms ping -n 1 Qmd2iHMauVknbzZ7HFer7yNfStR4gLY1DSiih8kjquPzWV; then true; fi
ipms files cp /ipfs/$qm /.brings
ipms files stat /.brings
