#!/bin/bash

pause () {
  # restrict action by run state
  [ -z "$runflag" ] && echo "Guest is halted. Boot first" && return 1

  # ensure guest is running before proceeding
  (echo "info status" | socat - tcp:$host:$monitorport | grep running) && pauseflag=0 
  [ "$pauseflag" != 0 ] && echo "Guest not running. Cannot pause" && return 1
  
  # pause emulation of guest
  echo "stop" | socat - tcp:$host:"$monitorport" > /dev/null
}
