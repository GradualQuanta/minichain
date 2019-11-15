#

bpath=/temp/blockchain

tic=$(date +%s)
nip=$(curl -s http://iph.heliohost.org/cgi-bin/remote_addr.pl | head -1)
peerid=$(ipfs config Identity.PeerID)

eval (ipfs files read $bpath/toc.yml | eyml)
echo "$owner:$bpath"
eval (ipfs files read $irqn | eyml)

qm=$(ipfs add -Q -)<<EOT
--- # pull request
From: $peerid
To: $owner
tic: $tic
nip: $nip
message: $envelop
payload: /files/$bpath/block.txt
signature: /files/$bpath/block.sig
code: $code
seq: $seq
...
pubkey: $peerid
sig: ~
EOT
echo qm: $qm
ipfs name publish --key=$irq --offline /ipfs/$qm

