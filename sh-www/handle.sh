#!/bin/bash

while true;
do
        read request

        GET=`echo "$request" | grep GET`
        GET=`echo "$GET" | tr ' ' '-' | cut -d/ -f2- | sed 's/-HTTP.*//'`
        #exit # debug code - just show us the value of $GET, then exit
        SCRIPT=`echo "$GET" | cut -d/ -f1`
        GUEST=`echo "$GET" | cut -d/ -f2`
        ACTION=`echo "$GET" | cut -d/ -f3`
        VALUE=`echo "$GET" | cut -d/ -f4`
        VALUE=$(printf "`printf "%s\n" "$VALUE" | sed -e 's/+/ /g' -e 's/%\(..\)/\\\\x\1/g'`") # urldecode this variable. it's urlencoded to make all conf.sh's required options fit in a -ingle variable (VALUE).
        PARAM=`echo "$GET" | cut -d/ -f5`

        if [ "$SCRIPT" = "api" ]; then
                Result=`vm "$GUEST" "$ACTION" $VALUE "$PARAM"`
                echo -e "HTTP/1.1 200 OK"
                echo -e "Date: `date -R | rev | cut -c 6- | rev`GMT"
                echo -e "Server: sh-httpd/0.0.1d (Unix)"
                echo -e "X-Powered-By: BASH/`bash --version | grep "bash, version" | cut -d- -f1 | cut -d, -f2 | cut  -c 10-`" # probably a bad idea to advertise the bash version here
                #echo -e "Content-Length: "
                #echo -e "Keep-Alive: timeout=5; max=100"
                echo -e "Connection: Keep-Alive"
                echo -e "Content-Type: text/html; charset=utf-8"
                echo -e "\r\n"
                cat /srv/sh-www/htdocs/response_header.html
                echo "GET: $GET" # debug code
                echo -e "<br /> \r\n"
                echo "Response: $Result"
                cat /srv/sh-www/htdocs/response_footer.html
                exit
        else
                echo -e "HTTP/1.1 200 OK"
                echo -e "Date: `date -R | rev | cut -c 6- | rev`GMT"
                echo -e "Server: sh-www/0.0.1d (Unix)"
                echo -e "X-Powered-By: BASH/`bash --version | grep "bash, version" | cut -d- -f1 | cut -d, -f2 | cut  -c 10-`"
                #echo -e "Content-Length: "
                #echo -e "Keep-Alive: timeout=5; max=100"
                echo -e "Connection: Keep-Alive"
                echo -e "Content-Type: text/html; charset=utf-8"
                echo -e "\r\n"
                cat /srv/sh-www/htdocs/response_header.html
                echo "GET: $GET" # debug code
                echo -e "<br /> \r\n"
                echo -e "Error: 0 malformed api request"
                #echo "$SCRIPT" # debug code i think?
                cat /srv/sh-www/htdocs/response_footer.html
                exit
        fi
done
