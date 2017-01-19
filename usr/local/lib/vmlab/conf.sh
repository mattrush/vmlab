#!/bin/bash

conf_usage () {
cat<<EOF
usage: $0 options

OPTIONS:
  -h	Show this message
  -C	Print the current guest metadata configuration file
  -v	Verbose output
  -f	Force reconfigure a guest
  -u	Specify a uuid to assign the guest. -u '' generates one at random
  -o	Operating system or template name
  -m	Memory size in MB
  -s	Disk size in GB, for example "$SCRIPT_ID -s 10G"
  -l	Lab name. Defaults to 'default'.
  -n	Network interface driver
  -b	Boot device for installation / rescue media
  -w	Upon receiving the halt api call, number of seconds to wait before issuing the kill api call
  -H	Hardware mac address
  -p	Base port number (used to calculate vnc, websocket, spice, as well as serial console and Qemu monitor ports). -p '' generates one at random
  -d	Datadisks to mount -- can be used up to four times
  -c	Cryptlock is set to 1 to enable, and anything else to disable. Uses a gpg key to decrypt a guest image before boot end re-encrypt after halt. Defaults to 1.
  -K	Path to a kernel you want to boot.
  -A	Comma-delimited kernel boot parameter string.
  -I	Path to an initrd image you want to boot.
EOF
}

vm_conf () {
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
      u)
        uuid="$OPTARG"
	;;
      o)
        os="$OPTARG"
	nicdriver=$(nic_depends_on_os) #FIXME this is a breakfix. this should aleady be getting set conditionaly by etc/vmlab/defaults.conf
	;;
      m)
        mem="$OPTARG" 
        ;;
      s)
        size="$OPTARG" 
        ;;
      l)
        lab="$OPTARG" 
        ;;
      n)
        nicdriver="$OPTARG" 
        ;;
      b)
        bootdevice="$OPTARG" 
        ;;
      w)
        wait_="$OPTARG" 
        ;;
      H)
        mac="$OPTARG" 
        ;;
      p)
        port="$OPTARG" 
        ;;
      a)
        access="$OPTARG"
        ;;
      d)
        datadisks='('"$OPTARG"')'
	;;
      c)
        cryptlock="$OPTARG"
        ;;
      K)
        kernel="$OPTARG"
	kernel=$(echo $kernel |sed -e 'sx/x\\/xg')
        ;;
      A)
        append="$OPTARG"
	append="$(echo $OPTARG |sed -e 'sx/x\\/xg')"
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

  # retest and set necessary defaults
  test_and_set_defaults
  unset verboseflag

  # if the guest's lab does not exist, create lab directory
  [[ $guest =~ / ]] && echo lab yes
  exit

  # restrict configuration when the guest is already configured and exists (not a new guest)
  if [ -e "$imagepath/$guest.img" ]; then
    if [ -e "$configurationpath/$guest.conf" ]; then
      [ -z "$forceflag" ] && echo "conf: Guest exists. Use -f to force reconfigure" && return 1
      mv $configurationpath/{,.$(date $dateformat).}$guest.conf
    fi
  fi
  
  # create a skeleton configuration file
  $(cp $configurationpath/.SKEL.conf $configurationpath/$guest.conf) &
  wait $! 
  
  # override default if set by options
  [ -n "$uuid" ] && sed -i -e "s/uuid=/uuid=$uuid/" $configurationpath/$guest.conf
  [ -n "$os" ] && sed -i -e "s/os=/os=$os/" $configurationpath/$guest.conf
  [ -n "$mem" ] && sed -i -e "s/mem=/mem=$mem/" $configurationpath/$guest.conf
  [ -n "$size" ] && sed -i -e "s/size=/size=$size/" $configurationpath/$guest.conf
  [ -n "$lab" ] && sed -i -e "s/lab=/lab=$lab/" $configurationpath/$guest.conf
  [ -n "$nicdriver" ] && sed -i -e "s/nicdriver=/nicdriver=$nicdriver/" $configurationpath/$guest.conf
  [ -n "$bootdevice" ] && sed -i -e "s/bootdevice=/bootdevice=$bootdevice/" $configurationpath/$guest.conf
  [ -n "$wait_" ] && sed -i -e "s/wait=/wait=$wait_/" $configurationpath/$guest.conf
  [ -n "$mac" ] && sed -i -e "s/mac=/mac=$mac/" $configurationpath/$guest.conf
  [ -n "$port" ] && sed -i -e "s/port=/port=$port/" $configurationpath/$guest.conf
  [ -n "$access" ] && sed -i -e "s/access=/access=$access/" $configurationpath/$guest.conf
  [ -n "$datadisks" ] && sed -i -e "s/datadisks=/datadisks=$datadisks/" $configurationpath/$guest.conf
  [ -n "$cryptlock" ] && sed -i -e "s/cryptlock=/cryptlock=$cryptlock/" $configurationpath/$guest.conf
  [ -n "$kernel" ] && sed -i -e "s/kernel=/kernel=$kernel/" $configurationpath/$guest.conf
  [ -n "$append" ] && sed -i -e "s/append=/append=$append/" $configurationpath/$guest.conf
  [ -n "$initrd" ] && sed -i -e "s/initrd=/initrd=$initrd/" $configurationpath/$guest.conf
}
