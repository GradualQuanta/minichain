#
export IPMS_HOME="${IPMS_HOME:-$HOME/.ipms}"

export PATH="$(pwd)/bin:$IPMS_HOME/bin:$PATH"
perl -S dot2yml deps.dot 
perl -S ymake deps.yml minichain
