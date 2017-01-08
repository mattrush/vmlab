#!/bin/bash

# boot a newly built kernel & initrd, and pass the kernel boot prompt some options to enable more verbose debug output. borne of the infamous 'no init found' kernel error. see kernel source 'Documentatiton/init.txt'.
pre-install_ () {
  # restrict action by run state
  [ -n "$runflag" ] && echo "Guest is running. Halt first" && return 1	

  # make sure guest is new
  [ ! -e "$imagepath/new.$guest.img" ] && echo "Guest is not new. Cannot install" && return 1

  # if chroot directory doesn't exist, create it
  [ ! -d "$chroot" ] && mkdir "$chroot"


  append="$(echo $append |sed -e 's/,/ /g')"
  #echo : "$append" :
  #exit

  # boot guest to installation media
  qemu-kvm \
    -hda "$imagepath/new.$guest".img \
    -m "$mem" \
    -device "$nicdriver",netdev="$guest",mac="$mac" \
    -netdev tap,id="$guest" \
    -vga vmware \
    -usbdevice tablet \
    -daemonize \
    -k en-us \
    $accessmethod \
    -serial tcp::"$serialport",server,nowait \
    -monitor tcp::"$monitorport",server,nowait \
    -enable-kvm \
    -pidfile "$pidfile" \
    -chroot "$chroot" \
    -runas nobody \
    -kernel "$kernel" \
    -initrd "$initrd" \
    -append "$append" #\
    #-"$bootdevice" "$isopath/$os"

  # if success, rename guest image to indicate it's not new anymore
  #(ps aux |grep -v grep |grep qemu-kvm |grep "$guest") && 
  es=$?; [ "$es" == 0 ] && mv $imagepath/{new.,}$guest.img && return 0 || return 1
}
