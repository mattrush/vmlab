#!/bin/bash

LAB_NAME="$1"

lab_conf () {
if [ -z "$LAB_NAME" ]; then
	echo "Lab name not specified"
	return
fi

pushd conf > /dev/null
while read i; do
		
	echo "$i configured"
done < /home/m/guest/lab/$LAB_NAME.lab
popd > /dev/null
} 2> /dev/null
