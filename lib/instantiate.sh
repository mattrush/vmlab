#!/bin/bash

instantiate_usage () {
usage: $0 options

OPTIONS:
  -h	Show this message
  -v	Verbose output
  -t	Template name on which to base the guest
EOF
}

# create a guest from a template
instantiate () {
  # restrict action if guest exists by that name
  (ls $imagepath/$guest.img &>/dev/null) && echo "Guest name already in use. Use a different name" && return 1	

  # handle options
  while getopts ":hvt:" opt; do
    case $opt in
      h)
        instantiate_usage
        return 0
        ;;
      v)
        verboseflag=1
        ;;
      t)
        template=$OPTARG
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

  # make -t option mandatory
  [ -z "$template" ] && echo "Option -t is mandatory. Cannot instantiate without a template" && return 1

  # make sure the template exists
  (ls $templatepath/$template.img &>/dev/null)
  [ "$?" != 0 ] && echo "No such template. Cannot instantiate" && return 1

  #create a default configuration file for the new guest
  (vmlab $guest conf -f)
  [ -d /etc/guestrc ] && source "$configurationpath/$guest.conf" 2> /dev/null

  # copy the template into a guest
  cp "$templatepath/$template.conf" "$configurationpath/$guest.conf"
  cp "$templatepath/$template.img" "$imagepath/$guest.img"

  return 0
}
