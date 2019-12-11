# 

# installation [script](https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/_data/install.yml)

export BRNG_HOME=$HOME/.brings
export IPMS_HOME=$HOME/.imps
export IPFS_PATH=$HOME/.brings/ipfs
export PERL5LIB=$HOME/.brings/perl5/lib/perl5

# 1. INSTALLING IPFS ...
# ----------------------

echo $IPMS_HOME/bin/bootstrap.sh
curl -s https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/.ipms/bin/bootstrap.sh | sh /dev/stdin

echo starting daemon
curl -s https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/start.sh | sh /dev/stdin

# 2. SETTING BRNG ENVIRONMENT ...
# --------------------------------

# ipfs add -r -Q $PROJDIR/.brings/bootstrap/bin/envrc.sh
eval "$($IPFS_PATH/bin/ipms cat QmP4GqXnZtcNUQF94Qx3UCynQKoMtcAEA5HfQ8FZ4Jkw9i)"

# 3. INSTALLING LOCAL PERL MODULES ...
# ------------------------------------

echo installing ${PERL5LIB%/lib/perl}

echo running /.brings/boostrap/perl5/install-local-lib.sh
ipms files read /.brings/bootstrap/perl5/install-local-lib.sh | sh /dev/stdin
#curl -s https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/.brings/bootstrap/perl5/install-local-lib.sh | sh /dev/stdin

echo running /.brings/bootstrap/perl5/install_modules.sh
ipms files read /.brings/bootstrap/perl5/install_modules.sh | sh /dev/stdin
#curl -s https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/.brings/bootstrap/perl5/install_modules.sh | sh /dev/stdin


