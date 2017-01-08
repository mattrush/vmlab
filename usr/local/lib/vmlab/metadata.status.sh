#!/bin/bash

status_vm () {
	# check for instance duplicity
	INSTANCE_QUANTITY_=`ps aux | grep qemu | grep "$guest" | grep -v "grep" | wc -l`
	if [ "$INSTANCE_QUANTITY" -gt 1 ]; then
		echo "Error: $guest duplicitous instance: $INSTANCE_QUANTITY `date`"
		return 1
	fi

	# discover and return guest status
	guest_STATE=`echo "info status" | socat - tcp:0.0.0.0:"$monitorport" | grep : | cut -d: -f 2- | tr -d ' '`
	echo "Guest state: $guest $guest_STATE"
}
