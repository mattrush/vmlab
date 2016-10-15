#!/bin/bash

reboot_ () {
  # restrict action by run state
  [ -z "$runflag" ] && echo "Guest is halted. Boot first" && return 1	

  # graceful restart
  (vmlab $guest halt)&
  (
  while [ -e "$pidfile" ]; do
    sleep 0.25s
  done
  vmlab $guest boot
  )&
}
