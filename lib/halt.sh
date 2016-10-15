#!/bin/bash

# gracefully shutdown a running guest, via qemu monitor
halt_ () {
  # restrict action by run state
  [ -z "$runflag" ] && echo "Guest is halted. Boot first" && return 1	

  # check if guest is paused or migrating
  (echo "info status" | socat - tcp:$host:$monitorport | grep paused) && pausedflag=1
  [ "$pausedflag" == 1 ] && echo "Guest is paused. Cannot halt" && return 1
  (echo "info migrate" | socat - tcp:$host:$monitorport | grep 'status:') && migrateflag=1
  [ "$migrateflag" == 1 ] && echo "Guest is migrating. Cannot halt" && return 1
  
  # tell the guest to powerdown
  (echo "system_powerdown" | socat - tcp:$host:"$monitorport" | grep -v QEMU | grep -v qemu)

  # handle guests who don't respect qemu monitor's halt
  (vmlab $guest repid)
  (
  until [ "$wait" == 0 ]; do
    ((wait--))
    (ps aux |awk '{print$2}' |grep $(cat $pidfile) &>/dev/null) || return 0
    sleep 1s
  done
  (vmlab $guest kill)
  return 1
  )&

  # wait till the guest is dead, then clean up 
  (
  while :; do
    (ps aux |awk '{print$2}' |grep $(cat $pidfile) &>/dev/null) || break
    sleep .5s
  done
  rm -rf $chroot && rm $pidfile
  return 0
  )&
}
