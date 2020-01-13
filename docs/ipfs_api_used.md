## API for IPMS

<!--
 $Source: /public/docs/ipms_api_used.md $
 $Previous: ~$
-->
### IPMS commands


  * bradd
  * brpublish
  * brsync (brget + brmerge)

  

### environment setup

 make sure IPFS_PATH, BRNG_HOME, PERL5LIB are properly set

 source $PROJDIR/envrc.sh

### mfs filesystem

 mfs is a local mutable file system, where you can give human readable name
 to ipfs content (hashes), all files are local and not visible to other unless
 specifically published.

 the files are accessible via the *ipms files* commands 

#### bradd: add a file to the blockring

 usage: bradd [--update] [--offline] <localfile>

 the localfile can be any file. 

 bradd extracts RCS keywords such as "$Source: ", "$Previous: ", and "$mutable:"

 if "$mutable:" keywords exists, bradd creates a history file there.
 if "$previous:" keywords exists, bradd computes the previous hash 
 by doing a "stat" on the mfs-path ... and update the file.
 if no previous exist 

 bradd compute the sha256 of the file content.
 place the content in the IPFS repository (located in $IPFS_PATH/blocks/)

 the bradd command updates the brindex.log

 underneaf bradd is calling : 

  * "ipms files stat --hash $source"
  * "ipms files rm $source"
  * "ipms add $file"
  * "ipms files cp $qm $source"
  * "ipms files append $mutable"

#### brpublish : 

 creates an identity if necessary
 # 
 append identity.log history with latest version of /my/identity/
 append public.log history with latest version of /public
 append root.log history with latest version of /root
 append my.log history with latest version of /my

 append brings.log history with latest version of /.brings
 ipms name publish --key=self .brings' hash.
 


### signature scheme under IPMS 

  /my/files/unsigned/docu1.docx
  /my/files/unsigned/docu2.docx

  /my/files/signed/docu1.docx (signature 1 (non executed, simple move of files))
  /my/files/signed/docu2.docx (signature 2 (non executed, simple move of files))
  ...
  brpublish /my/files/./signed
      (signature all execuded when publish i.e. using priv/pub key pair) 


