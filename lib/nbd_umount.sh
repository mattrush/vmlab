#!/bin/bash

nbd_umount () {
  # restrict action by run state
  [ -n "$runflag" ] && echo "Guest is running. Halt first" && return 1	

	UMOUNTEE=`cat $LOC/../run/$guest.mount`
	if [ -z "$UMOUNTEE" ]; then
		echo "Error: guest image not mounted"
		return 1
	fi

	umount "$UMOUNTEE" && rm $LOC/../run/$guest.mount || echo "Error: unmount $UMOUNTEE failed"
	qemu-nbd -d `cat $LOC/../run/$guest.nbd` && rm $LOC/../run/$guest.nbd || echo "Error: guest image nbd detach failed"
	rmdir $LOC/../mnt/$guest/ || echo "Error: failed te remove guest image mount point"

	unset UMOUNTEE
}
