#

qm=$(ipms add -r -Q .)
if ipms files stat --hash /.brings/bootstrap/bin 1>/dev/null; then
 ipms files rm -r /.brings/bootstrap/bin
else
  ipms files mkdir -p /.brings/bootstrap
fi
ipms files cp /ipfs/$qm /.brings/bootstrap/bin
ipms files stat /.brings/bootstrap/bin
exit $?


