#!/bin/bash

# install from iso or floppy onto a new guest
install_ () {
  # restrict action by run state
  [ -n "$runflag" ] && echo "Guest is running. Halt first" && return 1	

  if [[ -n $lab ]]; then
    # make sure guest is new
    [ ! -e "$imagepath/$lab/new.$gName.img" ] && echo "Guest is not new. Cannot install" && return 1
    qString='-hda "$imagepath/$lab/new.$gName".img \'
  else
    # make sure guest is new
    [ ! -e "$imagepath/new.$guest.img" ] && echo "Guest is not new. Cannot install" && return 1
    qString='-hda "$imagepath/new.$guest".img \'
  fi

  # if chroot directory doesn't exist, create it
  [ ! -d "$chroot" ] && mkdir -p "$chroot"

  # boot guest to installation media
  qemu-kvm \
    "$qString"
    -hda "$imagepath/new.$guest".img \
    -m "$mem" \
    -device "$nicdriver",netdev="$lab.$uuid",mac="$mac" \
    -netdev tap,id="$lab.$uuid" \
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
    -"$bootdevice" "$isopath/$os" #-cpu pentium3

  # if success, rename guest image to indicate it's not new anymore
  #(ps aux |grep -v grep |grep qemu-kvm |grep "$guest") && 
  [[ -n $lab ]] && {
    es=$?; [ "$es" == 0 ] && mv $imagepath/{new.,}$guest.img && return 0 || return 1
  } || {
    es=$?; [ "$es" == 0 ] && mv $imagepath/$lab/{new.,}$gName.img && return 0 || return 1
  }
}
