# 

set -e
# installation [script](https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/_data/install.yml)

if test -e config.sh; then
. ./config.sh
else
export IPMS_HOME=$HOME/.ipms
export PERL5LIB=$HOME/.brings/perl5/lib/perl5

export BRNG_HOME=/tmp/.brings
export IPFS_PATH=/tmp/.brings/repos
fi

# 1. INSTALLING IPFS ...
# ----------------------

echo $IPMS_HOME/bin/bootstrap.sh
curl -s https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/.ipms/bin/bootstrap.sh | sh /dev/stdin

sleep 3
echo starting daemon
curl -s https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/start.sh | sh /dev/stdin

# 2. SETTING BRNG ENVIRONMENT ...
# --------------------------------

# ipms add -r -Q $PROJDIR/.brings/bootstrap
xurl=/.brings/minimal/bin/install.sh
url=https://raw.githubusercontent.com/Gradual-Quanta/minichain/master${xurl}
qm=$(ipms add -Q $url --progress=0)
$IPMS_HOME/bin/ipms cat /ipfs/$qm | sh -xe /dev/stdin
#curl -s https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/.brings/minimal/bin/install.sh | sh /dev/stdin
#$IPMS_HOME/bin/ipms cat /ipns/QmVQd43Y5DQutAbgqiQkZtKJNd8mJiZr9Eq8D7ac2PeSL1/bin/install.sh | sh -xe /dev/stdin
eval "$($IPMS_HOME/bin/ipms files read /.brings/minimal/envrc.sh)"

# 3. INSTALLING LOCAL PERL MODULES ...
# ------------------------------------

echo installing ${PERL5LIB%/lib/perl}

echo running /.brings/boostrap/perl5/install-local-lib.sh
ipms files read /.brings/bootstrap/perl5/install-local-lib.sh | sh /dev/stdin
#curl -s https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/.brings/bootstrap/perl5/install-local-lib.sh | sh /dev/stdin

echo running /.brings/bootstrap/perl5/install_modules.sh
ipms files read /.brings/bootstrap/perl5/install_modules.sh | sh /dev/stdin
#curl -s https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/.brings/bootstrap/perl5/install_modules.sh | sh /dev/stdin


echo stopping daemon
curl -s https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/stop.sh | sh /dev/stdin
