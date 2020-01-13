# 
# vim: sw-3 et ai
BRNG_HOME=${BRNG_HOME:-$HOME/.brings}
if test ! -e $BRNG_HOME/system; then
# if not locally
  if qm=$(ipms files stat --hash /.brings/system 2>/dev/null); then
  # if exist on mfs
    ipms get $qm -o $BRNG_HOME/system
  else
  # ipms name publish --key=minimal $(ipms add -r -Q $PROJDIR/mfs/.brings/)
    key='QmVQd43Y5DQutAbgqiQkZtKJNd8mJiZr9Eq8D7ac2PeSL1' # minimal's key
    if ipath=$(ipms resolve $key/system); then
      ipms file cp $ipath /.brings/system
    else

      if [ "x$PROJDIR" != 'x' ] && [ -d "$PROJDIR" ]; then
	 qm=$(ipms add -r -Q $PROJDIR/.brings/system)
      else 
          qm='QmbXjzH9LzbxP7pCstKVEQZdXyLDkP2jAZFstzbfe9ju4W';
      fi
      ipms file cp /ipfs/$qm /.brings/system
    fi
  fi
else
 qm=$(ipms add -r -Q $BRNG_HOME/system)
fi

