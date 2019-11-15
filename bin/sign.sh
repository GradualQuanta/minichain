#

doc="$1"
hash=$(ipfs add -Q -n $doc --hash shake-224)
tics=$(date +%s)
nip=$(curl https://iph.heliohost.org/cgi-bin/remove_addr.pl | head -1)
peerid=$(ipfs config Identity.PeerID)
eval "$(ipfs files read /my/identity/public.yml | eyml)"
echo "doc: $doc"
echo "hash: $hash"
echo "tics: $tics"
echo "nip: $nip"
echo "peerid: $peerid"
echo "aka: $aka"
ipfs files stat --hash $attr/pubkey.yml
