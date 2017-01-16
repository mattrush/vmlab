#!/bin/bash

boot () {
  # restrict action by run state
  [ -n "$runflag" ] && echo "Guest is running. Halt first" && return 1
	
  # create chroot dir if doesn't exist
  [ ! -d "$chroot" ] && mkdir -p "$chroot"

  # boot the guest
  qemu-kvm \
    -hda "$imagepath/$guest".img \
    -m "$mem" \
    -netdev tap,id="$guest" \
    -device "$nicdriver",netdev="$guest",mac="$mac" \
    -vga vmware \
    -usbdevice tablet \
    -balloon virtio \
    -daemonize \
    -k en-us \
    $accessmethod \
    -serial tcp::"$serialport",server,nowait \
    -monitor tcp::"$monitorport",server,nowait \
    -enable-kvm \
    -pidfile "$pidfile" \
    -chroot "$chroot" \
    -runas nobody
    #-usbdevice host:1058:0820 \
}
