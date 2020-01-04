#
# defaults:
export PROJDIR=$(pwd)
MFS_HOME=${MFS_HOME:-$PROJDIR/mfs}
echo "MFS: $MFS_HOME"
export IPMS_HOME=${IPMS_HOME:-$HOME/.ipms}
export BRNG_HOME=${BRNG_HOME:-$HOME/.brings}
export IPFS_PATH=${IPFS_PATH:-$HOME/.brings/ipfs}
export PERL5LIB=${PERL5LIB:-$HOME/.brings/perl5/lib/perl5}

#PATH="$MFS_HOME/.brings/bin:$PATH"

echo "$0: Blockring Configuration script"
if test -e config.sh; then
	. $(pwd)/config.sh
else
 # Ask questions ...

# -------------------------------------------
echo where do you want to install IPMS software? 
echo -n "[$IPMS_HOME] "
read ans
if [ "x$ans" != 'x' ]; then
export IPMS_HOME=$ans
fi
# -------------------------------------------
echo where do you want to install Perl5 local modules ? 
echo -n "[$PERL5LIB] "
read ans
if [ "x$ans" != 'x' ]; then
export PERL5LIB=$ans
fi
# -------------------------------------------
echo where do you want to store blockring data ?
echo -n "[$BRNG_HOME] "
read ans
if [ "x$ans" != 'x' ]; then
export BRNG_HOME=$ans
fi
# -------------------------------------------
echo where do you want to IPFS repository ?
echo -n "[$IPFS_PATH] "
read ans
if [ "x$ans" != 'x' ]; then
export IPFS_PATH=$ans
fi
# -------------------------------------------
# write out config.yml for next time!
cat > config.sh <<EOF
# ipms config files
export PROJDIR=$PROJDIR
# ------------
export MFS_HOME=\${MFS_HOME:-$MFS_HOME}
export IPMS_HOME=\${IPMS_HOME:-$IPMS_HOME}
export PERL5LIB=\${PERL5LIB:-$PERL5LIB}
export BRNG_HOME=\${BRNG_HOME:-$BRNG_HOME}
export IPFS_PATH=\${IPFS_PATH:-$IPFS_PATH}
EOF
chmod a+x config.sh

fi

if [ "xPROJDIR" != 'x' ]; then echo "PROJDIR: $PROJDIR"; fi
echo "MFS_HOME: $MFS_HOME"
# copy envrc to $BRNG_HOME/
BRNG_HOME=${BRNG_HOME:-$HOME/.brings}
SRC=$MFS_HOME/.brings
rsync -auv $SRC/envrc.sh $BRNG_HOME/

cat > envrc.sh <<EOF
# config ($(date +'%D %T'))
export IPMS_HOME=${IPMS_HOME:-$HOME/.ipms}
export BRNG_HOME=${BRNG_HOME:-$HOME/.brings} 
export IPFS_PATH=\${IPFS_PATH:-\$HOME/.brings/ipfs}
if [ -d PERL5LIB=\$HOME/.brings/perl5/lib/perl5 ]; then
    export PERL5LIB=\$HOME/.brings/perl5/lib/perl5
else
  echo "PERL5LIB: not properly set (\$PERL5LIB)."
fi

if ! test -e \$IPFS_PATH/config; then
  echo "IPFS_PATH: not properly set (\$IPFS_PATH)."
  return $$
fi

if test -e \$BRNG_HOME/envrc.sh; then
. \$BRNG_HOME/envrc.sh
else
export PATH="\$BRNG_HOME/bin:\$IPMS_HOME/bin:\$PATH"
fi

if [ "x\$PROJDIR" = 'x' ]; then
PROJDIR=$(pwd)
PATH="\$PROJDIR/bin:\$PATH"
fi

if ! ipms swarm addrs local 1>/dev/null 2>&1; then
  echo "WARNING: no ipms daemon running !"
  ipmsd.sh
else
  echo "ipms already running"
fi

EOF
echo "please source the $(pwd)/envrc.sh file"


