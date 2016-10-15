#!/bin/bash

# install the hypervisor api
cp -v sh-www/rc.sh-www /etc/rc.d/
cp -vR sh-www/{htdcos,handle.sh} /srv/sh-www/
chmod +x /etc/rc.d/rc.sh-www
/etc/rc.d/rc.sh-www start
