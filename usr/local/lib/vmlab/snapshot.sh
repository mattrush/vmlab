#!/bin/bash

snap_usage () {
cat<<EOF
usage: $0 options

OPTIONS:
  -h	Show this message
  -v	Verbose output
  -f	Force reconfigure a guest
  -l	List existing snapshots
  -c	Create a snapshot
  -d	Delete a snapshot
  -a	Apply (revert) a snapshot
  -i	Dump image info
  -b	Dump image stack map for a given snapshot
EOF
}

snap () {
  # restrict action by run state. unless -C option is detected
  [ -n "$1" ] && [[ "$1" =~ /-C/g ]]
  if [ "$?" != 0 ]; then 
    [ -n "$runflag" ] && echo "Guest is running. Halt first" && return 1
  fi

  # handle options
  while getopts ":hCvfu:o:m:s:n:b:w:H:p:a:d:c:K:A:I:" opt; do
    case $opt in
      h)
        conf_usage
	exit 2
	;;
      C)
        cat $configurationpath/$guest.conf
	exit 2
	;;
      v)
        verboseflag=1
        ;;
      f)
        forceflag=1
	;;
      I)
        initrd="$OPTARG"
	initrd=$(echo $initrd |sed -e 'sx/x\\/xg')
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

  # 

  # override default if set by options
  [ -n "$initrd" ] && sed -i -e "s/initrd=/initrd=$initrd/" $configurationpath/$guest.conf
}
