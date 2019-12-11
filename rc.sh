
# ipfs add -r -Q $PROJDIR/.brings/bootstrap/bin/envrc.sh
envrc=QmP4GqXnZtcNUQF94Qx3UCynQKoMtcAEA5HfQ8FZ4Jkw9i
export BRNG_HOME=${BRNG_HOME:-$HOME/.brings}
export IPFS_PATH=${IPFS_PATH:-$BRNG_HOME/ipms}
export PERL5LIB=${PERL5LIB:-$BRNG_HOME/perl5/lib/perl5}
eval "$($IPFS_PATH/bin/ipms cat /ipfs/$envrc)"

