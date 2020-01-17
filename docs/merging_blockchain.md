## Merging 2 blockchains

# $Source: /public/docs/mychelium/merging-blocks.md$

# definition ...

 addr = hash(data)

 node = hash(block) (\/ node ] block = ipfs file)
 vertex = hash(payload)

 block = [payload,meta] 
 meta = [\previous,...]
 
 payload = block w/o immutable metadata (previous, ...)
           (block may contains mutables )
 
 parents = payload inheritence
         = payload of previous if no merge
 



# setup:

1.  blockchain A, owner: michel;
 
 A: genesis -> doc_v0 -> doc_v1 <= HEAD-A

2.  emile forks the blockchain A into blockchain B and create doc_v2b

 B: genesis -> doc_v0 -> doc_v1 -> doc_v2b <= HEAD-B


3.  michel continues to update blockchain A (merging doc_v2b & doc_v2a -> doc_v3_0a):

 A: genesis -> doc_v0 -> doc_v1 -> doc_v2a -> doc_v3_0a -> doc_v3_1a <= HEAD-A

4.  emile adds doc_v3b to blockchain B :

 B: genesis -> doc_v0 -> doc_v1 -> doc_v2b -> doc_v3b  <= HEAD-B

5.  emile wants to merge doc_v3_1a adding doc_v4b to blockchain B :

    a. find common ancestors on vertices graph between doc_v3b and doc_v3_1a = doc_v2b

    b. 


 


 



