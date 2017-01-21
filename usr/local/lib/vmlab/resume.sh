#!/bin/bash

resume () {
  # restrict action by run state
  [ -z "$runflag" ] && echo "Guest is halted. Boot first" && return 1	

  # ensure guest is paused before proceeding
  (echo "info status" | socat - tcp:$host:$monitorport | grep paused) && pauseflag=1 
  [ "$pauseflag" != 1 ] && echo "Guest not paused. Cannot resume" && return 1

  # resume emulation of guest
  echo "c" | socat - tcp:$host:$monitorport > /dev/null
}
