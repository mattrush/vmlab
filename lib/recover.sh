#!/bin/bash

# boot guest to recovery media
recover () {
  # restrict action by run state
  [ -n "$runflag" ] && echo "Guest is running. Halt first" && return 1	

  # create chroot dir
  [ ! -d "$chroot" ] && mkdir "$chroot"

  # boot the guest image to the install iso, for recovery
  qemu-kvm \
	-hda "$imagepath/$guest".img \
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
	-boot d \
	-"$bootdevice" "$isopath/$os"
}
