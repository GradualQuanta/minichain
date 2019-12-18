#
export IPMS_HOME="${IPMS_HOME:-$HOME/.ipms}"
#export IPFS_PATH=${IPFS_PATH:-$HOME/.ipms}

export PATH="$(pwd)/bin:$IPMS_HOME/bin:$PATH"
perl -S dot2yml deps.dot 
if which dot; then
dot deps.dot -Tpng -o deps.png; eog deps.png &
fi

perl -S ymake $1 deps.yml minichain

# $Source: /my/tools/blockchains/minichain/install.sh$
