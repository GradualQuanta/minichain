
# ipfs add -r -Q $PROJDIR/.brings/bootstrap/bin/envrc.sh
envrc=QmQgjkdTfDuZQjbuoqmGotxZzuwA1Z2onW648x1WToFCnB
export BRNG_HOME=${BRNG_HOME:-$HOME/.brings}
export IPMS_HOME=${IPFS_PATH:-$BRNG_HOME/.ipms}
export IPFS_PATH=${IPFS_PATH:-$BRNG_HOME/ipfs}
export PERL5LIB=${PERL5LIB:-$BRNG_HOME/perl5/lib/perl5}
eval "$($IPFS_PATH/bin/ipms cat /ipfs/$envrc)"

