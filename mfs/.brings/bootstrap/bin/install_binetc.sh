# 

BRNG_HOME=${BRNG_HOME:-$HOME/.brings}
qm=$(ipms files stat --hash /.brings/bin)
ipms get $qm -o $BRNG_HOME/bin
chmod a+x $BRNG_HOME/bin/*
qm=$(ipms files stat --hash /.brings/etc)
ipms get $qm -o $BRNG_HOME/etc
