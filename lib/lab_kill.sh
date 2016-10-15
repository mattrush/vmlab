#!/bin/bash

LAB_NAME="$1"

lab_kill () {
if [ -z "$LAB_NAME" ]; then
	echo "Error: Lab name not specified"
	return
fi

while read i; do
	vm $i repid
	vm $i kill
	echo $i killed
done < /home/m/guest/lab/$LAB_NAME.lab
} 2> /dev/null
