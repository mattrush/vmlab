#!/bin/bash

# create a new pidfile for guest, overwrite if it exists
repid () {
  # restrict action by run state
  [ -z "$runflag" ] && echo "Guest is halted. Boot first" && return 1	
  
  # create chroot dir if doesn't exist
  [ ! -d "$chroot" ] && mkdir -p "$chroot"

  # regenerate pidfile
  ps aux | grep qemu | grep "$guest" | awk '{print $2}' > "$pidfile"
}
