#!/bin/bash

nbd_mount_usage () {
usage: $0 options

OPTIONS:
  -h	Show this message
  -l	List patrtitions
  -p	Partition to mount
EOF
}

nbd_mount () {
  # restrict action by run state
  [ -n "$runflag" ] && echo "Guest is running. Halt first" && return 1	

  # handle options
  while getopts ":hlp:" opt; do
    case $opt in
      h)
        instantiate_usage
        return 0
        ;;
      l)
        listflag=1
        ;;
      p)
        target=$OPTARG
        ;;
      \?)
        echo "Invalid option: -$OPTARG" >&2
        return 1
        ;;
      :)
        echo "Option -$OPTARG requires an argument." >&2
        return 1
        ;;
    esac
  done

  # restrict action by guest state
  (ps aux |grep -v grep |grep qemu-kvm |grep $guest &>/dev/null)
  [ "$?" == 0 ] && echo "Guest is running, cannot mount. Halt first" && return 1

  # make -t option mandatory
  [ -z "$target" ] && echo "No partition specified. Cannot mount" && return 1

  # make sure the nbd module is loaded and correctly configured 
  (lsmod |grep nbd) || modprobe nbd max_part=$mountpoints

  # get the lowest nbd device number available
  mounted=( $(ls /dev |grep nbd |awk '{print $1}' |grep -v p |rev |cut -d d -f 1 |rev) )
  lowest=$(IFS=$'\n'; echo "${mounted[*]}" |sort -n |head -n +1)

  # mount the disk
  (qemu-nbd -c /dev/nbd$lowest "$imagepath/$guest.img")&
  wait $!
  mkdir -p "$mountpath/$guest"
  mount /dev/nbd"$lowest"p"$target" "$mountpath/$guest/"

  return 0
}
