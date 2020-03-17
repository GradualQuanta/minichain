## Immuable

immutable == content placed at the address = hash(content) 


   fixed content at fixed address (ipfs is immutable system == content addressable store))
   
   
## Mutable:

   address fixed for variable content (key value store)
   
   key -> {signed value + public key} stored at hash(public key)

1. ipns'mutable :
   mutable == variable content which has a signed reference to a immutable,
      and is placed at the address of the hash of the signer's public key.
           (mutables need to be published via gossip protocol)

2. mfs mutable (source) :
   mutable == variable content which is placed at a fixed path on mfs
   (mutables need to be published via owner's peerid)

3. ipms mutable (ipfs) :
   mutable == variable content which has a signed reference to a immutable,
     and is placed at the address "mutable-hash" on IPFS network i.e. fixed address

   mutable-hash(content1) == mutable-hash(content2) 
   

   
### example:

ipns'mutable : /ipns/QmcfHufAK9ErQ9ZKJF7YX68KntYYBJngkGDoVKcZEJyRve
mfs mutable: michel@mfs:/public/myfile.txt
ipms'mutable: /ipfs/z6D1ERe2CSjzD4PGUVxgezuVs1cXJreBh8nNApCAEwfr

### resolution performance

 a mutable need to be globally distibuted each time it is updated,
 the usual protocol to achieve this quickly is "[[gossip]]", which
 randomly broadcast to a subset of neightbors (discovered peers).
 
 anyone can distribute a mutable, this is why they are "signed",
 so only valid ones are kept (DDoS mitigation).
 each mutable have a limited life-time (TTL) i.e. they expired.
 
 resolution is done in a similar way by discovering the peers how has the requested files
 IPFS: collect 20 mutables to choose the best.
 
 This leads to a very slow resolution of mutables ...
 
 Annonymous Distibuted-Key-value-Store : extremement difficile ...

 IMHO:
  - (perfect turin machine = ! exists)
  - (perfect decentralize KVS = ! exits)

### IPMS approach :

  - Content-Addressable-Store are EASY (1 hash -> 1 value)
  - how can we have mutables stored on a CAS network (IPFS style)

    what we want : 1 hash -> 2 different content == /!\ hash collision !!!
    
    hash non-cryptographically secure can be mutables...   
    
    mut5(data0) = substr(SHA256(data0,timestamp),0,5) = ZREAF
    mut5(data1) = substr(SHA256(date1."nonce",timestamp),0,5) = ZREAF
    
    ident20("data012345678901234567.extra") = data012345678901234567
    
  - 2 new hash functions:
    mut224() shake-256, clipped to 224 (sponge: sha3 keccak  NIST3.0)
    ident20([hash,data]) = hash; (PR)
    
    extended identity = "modulo" ident .
    
    
    
    
 all this leading to slow time response
 



more info in resolve code: (https://discordapp.com/channels/553095799869931521/553139874149171210/672131869852041236)
```perl
my $addr = shift;
# bifurcation depending on address type
if ($addr =~ m{^(?:self@)?(?:mfs:|/files)(/.*)})  {
# local mutable address of type:
# . self@mfs:/mfspat
# . mfs:/mfspat
# . /files/mfspat (webui)
  $hash = &ipms_local_mutable_resolve('mfs:'.$1);

} elsif ($addr =~ m{\w+:(/ipns/.*)} ) { # P2P request 127.0.0.1:808)
  # dweb:/ipns/mkey (mutable)
  $hash = &ipms_name_resolve($1);
} elsif ($addr =~ m{ipfs:/(/.*)} ) { # immutable
  # ipfs://mhash
  $hash = &ipms_path_resolve('/ipfs'.$1);
} elsif ($addr =~ m{(/ipfs/.*)} ) { # immutable
  # /ipfs/mhash
  $hash = &ipms_path_resolve($1);
} elsif ($addr =~ m{(\w+)\@ipms:(/.*)} ) { # remote
  # nickname@ipms:/my/identity/public.yml
  $hash = &ipms_remote_mutable_resolve($1,$2);
} elsif ($addr =~ m{/ipms/(\w+)(/.*)} ) { # remote, using nickname
  # /ipms/nickname/path
  # /ipms/symbol/path
  $hash = &ipms_remote_mutable_resolve($1,$2);
} elsif ($addr =~ m{(\w+)\@mfs:(/.*)} ) { # remote, using keys
  # peeridkey@mfs:/mfspath
  # symbolkey@mfs:/mfspath
  $hash = &mfs_remote_mutable_resolve($1,$2);
} else {
  $hash = &mfs_unknow_resolve($addr);
}

```



## Blockchain:

  blockchain == files containing a immutable reference to a previous version (chained list of files)

## Blockring:

  blocring == mutable containing a sequence of immutable references (history log)



$Source: /public/docs/mychelium/mutable-definition.md$
$Previous: QmatcgcxAZHvUUguXFCDHKzoUSmn7WKKSh9njsqvLodTRf$


