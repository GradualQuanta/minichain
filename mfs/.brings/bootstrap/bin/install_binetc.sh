# 

MFS=${PROJDIR:-.}/mfs
if [ "xPROJDIR" != 'x' ]; then echo "PROJDIR: $PROJDIR"; fi
echo "MFS: $MFS"
BRNG_HOME=${BRNG_HOME:-$HOME/.brings}
SRC=$MFS/.brings
# cleanup from previous bug
if [ -e $BRNG_HOME/etc/etc ]; then
   rm -rf $BRNG_HOME/etc/etc
   rm -rf $BRNG_HOME/bin/bin
fi

rsync -auv $SRC/bin $BRNG_HOME/
chmod a+x $BRNG_HOME/bin/*
# error if fullname is not executable
if [ ! -x $BRNG_HOME/bin/fullname ]; then
   echo "$BRNG_HOME/bin/fullname is not executable" exit $$
fi

rsync -auv $SRC/etc $BRNG_HOME/
if [ ! -e $BRNG_HOME/etc/fnames.txt ]; then
   echo "$BRNG_HOME/etc/fnames.txt is missing" ; exit $$
fi
echo "${0##*/}: bin and etc installed"

exit $?
