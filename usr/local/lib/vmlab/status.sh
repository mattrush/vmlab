#!/bin/bash

status_vm () {
	# check for instance duplicity
	INSTANCE_QUANTITY_=`ps aux | grep qemu | grep "$GUEST" | grep -v "grep" | wc -l`
	if [ "$INSTANCE_QUANTITY" -gt 1 ]; then
		echo "Error: $GUEST duplicitous instance: $INSTANCE_QUANTITY `date`"
		exit 1
	fi

	# discover and return guest status
	GUEST_STATE=`echo "info status" | socat - tcp:0.0.0.0:"$MON" | grep : | cut -d: -f 2- | tr -d ' '`
	echo "Guest state: $GUEST $GUEST_STATE"
}
