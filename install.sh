#
export PATH="$(pwd)/bin:$PATH"
perl -S dot2yml deps.dot 
perl -S ymake deps.yml minichain
