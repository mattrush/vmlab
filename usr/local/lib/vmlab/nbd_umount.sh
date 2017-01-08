#!/bin/bash

nbd_umount () {
  # restrict action by run state
  [ -n "$runflag" ] && echo "Guest is running. Halt first" && return 1	

  # make sure guest is mounted
  (ps aux |grep -v grep |grep qemu-nbd |grep $guest |awk '{print $13}' &>/dev/null)
  [ "$?" != 0 ] && echo "Guest image not mounted. Cannot unmount" && return 1

  # unmount the disk
  umount "$mountpath/$guest"
  [ "$?" != 0 ] && echo "Guest umount failed" && return 1

  # detatch the disk from nbd
  qemu-nbd -d $(ps aux |grep -v grep |grep qemu-nbd |grep $guest |awk '{print $13}') &>/dev/null
  [ "$?" != 0 ] && echo "Guest image nbd detach failed" && return 1

  # clean up
  rmdir $mountpath/$guest

  return 0
}
