#!/bin/bash

# hard reset a guest via qemu monitorr like pushing the reset button
reset () {
  # restrict action by run state
  [ -z "$runflag" ] && echo "Guest is halted. Boot first" && return 1	

  # tell qemu to reboot the guest
  (echo "system_reset" | socat - tcp:$host:"$monitorport" | grep -v QEMU | grep qemu &>/dev/null) 
}
