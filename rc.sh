
boots=$($IPMS_HOME/bin/ipms files stat --hash /.brings/bootstrap)
export BRNG_HOME=${BRNG_HOME:-$HOME/.brings}
export IPMS_HOME=${IPMS_HOME:-$BRNG_HOME/.ipms}
export IPFS_PATH=${IPFS_PATH:-$BRNG_HOME/ipfs}
export PERL5LIB=${PERL5LIB:-$BRNG_HOME/perl5/lib/perl5}

# ipfs add -r -Q $PROJDIR/.brings/bootstrap/bin/envrc.sh
eval "$($IPMS_HOME/bin/ipms cat /ipfs/$boots/bin/envrc.sh)"

