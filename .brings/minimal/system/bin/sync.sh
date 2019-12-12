#

set -e
# this script sync up w/ mfs
# $qm: ~$
#
dir=$(pwd)
name=${dir##*/minimal/}
echo name: $name

qm=$(ipfs add -Q -r .)
if pv=$(ipfs files stat --hash /.brings/$name); then
 ipfs files rm -r /.brings/$name
 ipms files cp /ipfs/$qm /.brings/$name
 ipms files cp /ipfs/$pv /.brings/$name/prev
else
 if ipms files mkdir -p /.brings/$name 1>/dev/null; then true; fi
 ipms files cp /ipfs/$qm /.brings/$name
fi

exit $?;
true; # $Source: /.brings/system/bin/sync.sh$
