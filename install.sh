# 

set -e
red="[31m"; yellow="[33m"; green="[32m"; nc="[0m"
# installation [script](https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/_data/install.yml)

if test -e config.sh; then
. ./config.sh
else
export IPMS_HOME=$HOME/.ipms
export PERL5LIB=$HOME/.brings/perl5/lib/perl5

export BRNG_HOME=/tmp/.brings
export IPFS_PATH=/tmp/.brings/repos
fi

cat <<EOT
${yellow}# 1. INSTALLING IPFS ...
# ----------------------${nc}
EOT

echo $IPMS_HOME/bin/bootstrap.sh
curl -s https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/.ipms/bin/bootstrap.sh | sh /dev/stdin

echo "${green}starting daemon${nc}"
curl -s https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/start.sh | sh /dev/stdin
sleep 7

cat <<EOT
${yellow}# 2. SETTING BRNG ENVIRONMENT ...
# --------------------------------${nc}
EOT

# (assumed ipms is running)
xurl=/.brings/minimal/bin/install.sh
url=https://raw.githubusercontent.com/Gradual-Quanta/minichain/master${xurl}
qm=$($IPMS_HOME/bin/ipms add -Q $url --progress=0)
$IPMS_HOME/bin/ipms cat /ipfs/$qm | sh -xe /dev/stdin


cat <<EOT
${yellow}# 3. INSTALLING LOCAL PERL MODULES ...
# ------------------------------------${nc}
EOT

echo installing ${PERL5LIB%/lib/perl}

echo running /.brings/boostrap/perl5/install-local-lib.sh
ipms files read /.brings/bootstrap/perl5/install-local-lib.sh | sh /dev/stdin
#curl -s https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/.brings/bootstrap/perl5/install-local-lib.sh | sh /dev/stdin

echo running /.brings/bootstrap/perl5/install_modules.sh
ipms files read /.brings/bootstrap/perl5/install_modules.sh | sh /dev/stdin
#curl -s https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/.brings/bootstrap/perl5/install_modules.sh | sh /dev/stdin


echo stopping daemon
curl -s https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/stop.sh | sh /dev/stdin

cat <<EOT
${yellow}# 4. INSTALLING PROJECT RELATED ENVIRONMENT ...
# ---------------------------------------------${nc}
EOT

if [ "x$PROJDIR" = 'x' ]; then PROJDIR=$(pwd); fi
sed -i -e "s|^PROJDIR=\$(pwd)$|PROJDIR=$PROJDIR|" config.sh
echo config.sh created in $PROJDIR

echo "${green}done.${nc}"
