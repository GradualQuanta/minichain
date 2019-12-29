

user1:

genesis -> v0 -> v1 -> v2 -> myfile

user2: 
v1 -> v2.a -> yourfile 

user3:

myfile -> v3.b -> someone-else-file


merge_n(myfile,yourfile,some-else-file) =

  merge2(merge2(myfile,yourfile),some-else-file);

  merge2(a,b) = merge3(a,b,x=ancestor_commun(a,b));

<<<< yourfile [+3215 -3214 => rk: 12345]
  xa = merge3(a,b,z) = apply_patch(diff2(b,z),a) 
  xb = merge3(b,a,z) = apply_patch(diff2(a,z),b)
==== someone-else-file [+215 -421] => rk: 14]
  xa = merge3(a,b,y) = apply_patch(diff2(b,y),a) 
  xb = merge3(b,a,y) = apply_patch(diff2(a,y),b)
==== myfile [+4125 -6574 => rk: 32532]
  xa = merge3(a,b,x) = apply_patch(diff2(b,x),a) 
  xb = merge3(b,a,x) = apply_patch(diff2(a,x),b)
==== your new proposition ...
  // decide how to merge the 3 versions
  [...]
>>>>

  // note : xa = xb if a,b of CxRDT type
  ab = vote(xa,xb) 
  



