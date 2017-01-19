#!/bin/bash
# create a virtual root disk for a guest

create_usage () {
cat<<EOF
usage: $0 options

OPTIONS:
  -s	Disk size in GB, for example "$SCRIPT_ID -s 10G"
  -f	Force create. overwrites a new disk
  -v	Verbose output
  -h	Show this message
EOF
}

create () {
  # restrict action by run state
  [ -n "$runflag" ] && echo "Guest is running. Halt first" && return 1	

  # handle options
  while getopts ":s:fvh" opt; do
    case $opt in
      s)
        size="$OPTARG"
        ;;
      f)
        forceflag=1
        ;;
      v)
        verboseflag=1
        ;;
      h)
        create_usage
        return 0
        ;;
      \?)
        echo "Invalid option: -$OPTARG" && return 1
        ;;
      :)
        echo "Option -$OPTARG requires an argument." && return 1
        ;;
    esac
  done

  # make '-s' mandatory
  [ -z "$size" ] && echo "Create: -s option mandatory. Set a disk size" && return 1

  # handle verbosity
  [ -z "$verboseflag" ] && verbosity=" > /dev/null"
  
  # if the guest's lab does not exist, create lab directory
  [[ $guest ~= / ]] && echo lab yes
  exit

  # don't overwrite non-blank disks, and require -f to recreate newly created disks
  if [ -e ${imagepath}/${guest}.img ]; then
    echo "Create: guest already installed to disk. Use 'wipe' action to zero it out" && return 2
  elif [ -e ${imagepath}/new.${guest}.img ]; then 
    [ -z "$forceflag" ] && echo "Create: new disk already exists. Use -f to force overwrite" && return 1
  fi

  # create the disk
  verbosity="$(qemu-img create -f qcow2 ${imagepath}/new.${guest}.img $size)"
  [ -n "$verboseflag" ] && echo $verbosity
  return 0
}
