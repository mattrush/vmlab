#!/bin/bash

boot () {
  # restrict action by run state
  [ -n "$runflag" ] && echo "Guest is running. Halt first" && return 1

  if [[ -n $lab ]]; then
    # make sure guest is new
    [ ! -e "$imagepath/$lab/new.$gName.img" ] && echo "Guest is not new. Cannot install" && return 1
    nString="$lab/new.$gName".img
  else
    # make sure guest is new
    [ ! -e "$imagepath/new.$guest.img" ] && echo "Guest is not new. Cannot install" && return 1
    nString="new.$guest".img
  fi
	
  # create chroot dir if doesn't exist
  [ ! -d "$chroot" ] && mkdir -p "$chroot"

  # boot the guest
  qemu-kvm \
    -hda "$imagepath/$nString" \
    -m "$mem" \
    -netdev tap,id="$lab.$uuid" \
    -device "$nicdriver",netdev="$lab.$uuid",mac="$mac" \
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
