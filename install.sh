#

export PROJDIR=$(pwd); # $HOME/minichain
export BRNG_HOME="${BRNG_HOME:-$HOME/.brings}"

eval $(perl -I$PERL5LIB -Mlocal::lib=${PERL5LIB%/lib/perl5})
sh mfs/.brings/bootstrap/perl5/install-local-lib.sh
export PERL5LIB="${PERL5LIB:-$BRNG_HOME/perl5/lib/perl5}"
sh mfs/.brings/bootstrap/perl5/install_modules.sh
#
sh mfs/.brings/bootstrap/bin/install_binetc.sh
export PATH="$BRNG_HOME/bin:$PATH"
export DICT="$BRNG_HOME/etc"

#export IPMS_HOME="${IPMS_HOME:-$HOME/.ipms}"
if [ "x$USER" = 'xmichelc' ] && uname -r | grep -q 'Microsoft' ; then
export IPMS_HOME="${PROJDIR}/mfs/.ipms"
export IPFS_PATH="${IPFS_PATH:-$PROJDIR/mfs/.ipms}"
else
export IPMS_HOME="${IPMS_HOME:-$HOME/.ipms}"
export IPFS_PATH="${IPFS_PATH:-$BRNG_HOME/ipfs}"
fi
export PATH="$IPMS_HOME/bin:$PATH"

echo pwd: $(pwd)
sh mfs/.ipms/bin/bootstrap.sh

sh mfs/.brings/bootstrap/bin/install_system.sh

sh mfs/.brings/bootstrap/bin/mkconfig.sh

#perl -S dot2yml deps.dot 
#if which dot; then
#dot deps.dot -Tpng -o deps.png; eog deps.png &
#fi
#perl -S ymake $1 deps.yml minichain

# $Source: /my/tools/blockchains/minichain/install.sh$
