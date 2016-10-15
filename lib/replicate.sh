#!/bin/bash

replicate () {
  # restrict action by run state
  [ -z "$runflag" ] && echo "Guest is halted. Boot first" && return 1	

	# get src instance name
	if [ -z "$EXTRA" ]; then
		echo "Error: Missing parameter: Source instance name"
		return
	fi

	# ensure new instance name is unique
	NON_UNIQ=`ls $LOC/../img/* | grep "$EXTRA"`
	if [ -n "$NON_UNIQ" ]; then
		echo "Error: Non uniqe new instance name"
		return
	fi

	# copy src instance files with name of new instance
	NEW_NAME="$EXTRA"
	for i in img conf; do
		cp "$LOC/../$i/$guest.$i" "$LOC/../$i/$NEW_NAME.$i"
	done
	echo "$guest replicated as $NEW_NAME `date`"
}
