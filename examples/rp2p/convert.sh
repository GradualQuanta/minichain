#
file="$1"
name="${file%.*}"
echo name: $name
pandoc -f mediawiki -t markdown -o $name.md $file
pandoc -f mediawiki -t html -o $name.html $file
cp -p $name.html index.htm
bafy=$(ipfs add -r -Q . --cid-version=0 --cid-base base32)
echo url: https://$bafy.cf-ipfs.com/
