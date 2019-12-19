# 

MFS=${PROJDIR:-.}
BRNG_HOME=${BRNG_HOME:-$HOME/.brings}
SRC=$MFS/.brings
rsync -rp $SRC/bin $BRNG_HOME/bin
chmod a+x $BRNG_HOME/bin/*

rsync -rp $SRC/etc $BRNG_HOME/etc
