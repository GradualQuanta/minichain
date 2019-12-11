# 

# installation [script](https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/_data/install.yml)

export BRNG_HOME=$HOME/.brings
# 1. INSTALLING LOCAL PERL MODULES ...
# ------------------------------------

echo running .brings/perl5/boostrap.sh
curl -s https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/.brings/perl5/bootstrap.sh | sh /dev/stdin

echo running .brings/perl5/install_modules.sh
curl -s https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/.brings/perl5/install_modules.sh | sh /dev/stdin


# 2. INSTALLING IPFS ...
# ----------------------

echo .brings/ipms/bin/bootstrap.sh
curl -s https://raw.githubusercontent.com/Gradual-Quanta/minichain/master/.brings/ipms/bin/bootstrap.sh | sh /dev/stdin
