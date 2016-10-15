#!/bin/bash
# by mrush 02.18.2015

nfsHost=192.168.1.123
#lustreDtn=192.168.1.124

# give the app a user
grep -e "^vmlab:" /etc/passwd >/dev/null || umask=600 adduser -g nobody -h /dev/null -s /bin/false vmlab

# put the binaries and libraries in place
cp -v bin/vmlab /usr/local/bin/vmlab
cp -v lib/* /usr/local/lib/vmlab/

# create mount-points, mount, and populate
echo -e "/vmlab-iso nfs@$nfsHost ro 0 0\n/vmlab-tmpl nfs@$nfsHost ro 0 0\n/vmlab-data nfs@$nfsHost defaults 0 0" >> /etc/fstab
for i in iso tmpl data; do 
	mkdir -v /vmlab-$i
	mount -o rw /vmlab-$i
	cp -v vmlab-$i/* /vmlab-$i/
	mount -o remount,ro /vmlab-$i
done

# install cron jobs
for i in daily weekly; do cp -v cron/$i/* /etc/cron.$i/; done

# install configuration files
cp -vRn etc/* /etc/

# create runtime directories
mkdir -v /var/{log,run}/vmlab
mkdir -pv /var/vmlab/trash

# install the hypervisor api
cp -v sh-www/rc.sh-www /etc/rc.d/
cp -vR sh-www/{htdocs,handle.sh} /srv/sh-www/
chmod +x /etc/rc.d/rc.sh-www
/etc/rc.d/rc.sh-www start
