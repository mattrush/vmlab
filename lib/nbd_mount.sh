#!/bin/bash

SPECIFIER="$1"

nbd_mount () {
  # restrict action by run state
  [ -n "$runflag" ] && echo "Guest is running. Halt first" && return 1	

	guest_RUNNING=`ps aux | grep qemu-kvm | grep $guest | grep -v grep`
	if [ -n "$guest_RUNNING" ]; then
		echo "Error: guest image is running, cannot mount"
		return 1
	fi

	if [ -z "$SPECIFIER" ]; then
		echo "Error: image partition not specified"
		return 1
	fi

	unset MOUNTED HIGHEST_MOUNT NEXT_MOUNT 
	
	MOUNTED=( `ls /dev | grep nbd | awk '{print $1}' | grep -v p | rev | cut -d d -f 1 | rev` )
	(HIGHEST_MOUNT=`IFS=$'\n'; echo "${MOUNTED[*]}" | sort -nr | head -n1`; export HIGHEST_MOUNT)

	if [ -n "$HIGHEST_MOUNT" ]; then
		NEXT_MOUNT="$HIGHEST_MOUNT" + 1
	else
		NEXT_MOUNT="0"
	fi

	MODULE_LOADED=`lsmod | grep nbd`
	if [ -z "$MODULE_LOADED" ]; then
		`modprobe nbd max_part=16`
	fi

	qemu-nbd -c /dev/nbd$NEXT_MOUNT "$imagepath/$guest.img"
	mkdir -p "$mountpath/$guest"
	mount /dev/nbd"$NEXT_MOUNT"p"$SPECIFIER" "$mountpath/$guest/"

	echo /dev/nbd"$NEXT_MOUNT"p"$SPECIFIER" > "$RUN/$guest.mount"
	echo /dev/nbd"$NEXT_MOUNT" > "$RUN/$guest.nbd"

	unset MOUNTED HIGHEST_MOUNT NEXT_MOUNT guest_RUNNING
}
