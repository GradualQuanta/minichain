#

# copy envrc to $BRNG_HOME/
MFS=${PROJDIR:-.}/mfs
if [ "xPROJDIR" != 'x' ]; then echo "PROJDIR: $PROJDIR"; fi
echo "MFS: $MFS"
BRNG_HOME=${BRNG_HOME:-$HOME/.brings}
SRC=$MFS/.brings
rsync -auv $SRC/envrc.sh $BRNG_HOME/

cat > config.sh <<EOF
# config ($(date +'%D %T'))
export IPMS_HOME=${IPMS_HOME:-$HOME/.ipms}
export BRNG_HOME=${BRNG_HOME:-$HOME/.brings} 
export IPFS_PATH=\${IPFS_PATH:-\$HOME/.brings/ipfs}
export PERL5LIB=\$HOME/.brings/perl5/lib/perl5

if test -e \$BRNG_HOME/envrc.sh; then
. \$BRNG_HOME/envrc.sh
else
export PATH="\$BRNG_HOME/bin:\$IPMS_HOME/bin:\$PATH"
fi

if [ "x\$PROJDIR" = 'x' ]; then
PROJDIR=$(pwd)
PATH="\$PROJDIR/bin:\$PATH"
fi
EOF
echo "please source the $(pwd)/config.sh file"
