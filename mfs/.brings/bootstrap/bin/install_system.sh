# 

# vim: sw=3 ai et
MFS=${PROJDIR:-.}/mfs
if [ "xPROJDIR" != 'x' ]; then echo "PROJDIR: $PROJDIR"; fi
echo "MFS: $MFS"
BRNG_HOME=${BRNG_HOME:-$HOME/.brings}
SRC=$MFS/.brings
# cleanup from previous bug
if [ -e $BRNG_HOME/system ]; then
   rm -rf $BRNG_HOME/system
fi
rsync -auv $SRC/system $BRNG_HOME

#key='QmVQd43Y5DQutAbgqiQkZtKJNd8mJiZr9Eq8D7ac2PeSL1' # minimal's key
# ipms name publish --key=minimal $(ipms add -r -Q $PROJDIR/.brings/minimal)
#ipath=$(ipms resolve $key/system)
#qm='QmbXjzH9LzbxP7pCstKVEQZdXyLDkP2jAZFstzbfe9ju4W';
#ipms get $qm -o $BRNG_HOME/system --progress=0

#chmod a+x $BRNG_HOME/system/bin/*
if [ ! -e $BRNG_HOME/system/bin/add.sh ]; then
   echo "$BRNG_HOME/system/bradd is missing" ; exit $$
fi
echo "${0##*/}: system installed"
exit $?
true; # $Source: /my/tools/brings/install/scripts/install_system.sh$
