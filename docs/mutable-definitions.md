## Immuable

immutable == content placed at the address = hash(content) 

   fixed contenty at fixed address 

## Mutable:

   address fixed for variable content

1. ipns'mutable :
   mutable == variable content which has a signed reference to a immutable, and is placed
           at the address of the hash of the signer's public.
           (mutables need to be published via gossip protocol)

2. mfs mutable (source) :
   mutable == variable content which place at a fixed path on mfs
   (mutables need to be published via owner's peerid)

3. ipms mutable (ipfs) :
   mutable == variable content which has a signed reference to a immutable, and is placed
              at the address "mutable-hash" on IPFS network i.e. fixed address

   mutuable-hash(content1) == mutable-hash(content2) 

## Blockchain:

  blockchain == files containing a immutable reference to a previous version (chained list of files)

## Blockring:

  blocring == mutable containing a sequence of immutable references (history log)



$Source: /public/docs/mutable-definition.md$
$Previous: QmatcgcxAZHvUUguXFCDHKzoUSmn7WKKSh9njsqvLodTRf$


