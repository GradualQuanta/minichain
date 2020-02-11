#

cat > data.txt <<EOF
Date: $(date)

This is the data.txt file !
-- $$
${USER}
EOF
echo "dbug: "
#curl -F file=@data.txt "https://iph.heliohost.org/cgi-bin/posted.pl?cmd=write&arg=/tmp/myfile&create=true" | grep -v '^X-'
#curl -F file=@data.txt "http://127.0.0.1:8088/GITrepo/websites/helio/cgi-bin/posted.pl?cmd=write&arg=/tmp/myfile&create=true" | grep -v '^X-'
curl -F file=@data.txt "https://postman-echo.com/post?cmd=write&arg=/tmp/myfile&create=true"
ipms files rm /tmp/myfile 2>/dev/null
echo .
echo "write: "
curl -F file=@data.txt "http://localhost:5121/api/v0/files/write?arg=/tmp/myfile&create=true"
echo " $?"
echo "read: "
ipms files read /tmp/myfile

