#!/bin/bash

templatize_usage () {
usage: $0 options

OPTIONS:
  -h	Show this message
  -v	Verbose output
  -t	Template name on which to base the guest
EOF
}

# create a template from a guest
templatize () {
  # restrict action by run state
  [ -n "$runflag" ] && echo "Guest is running. Halt first" && return 1
	
  # handle options
  while getopts ":hvt:" opt; do
    case $opt in
      h)
        templatize_usage
        return 0
        ;;
      v)
        verboseflag=1
        ;;
      t)
        templatename=$OPTARG
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
  [ -z "$templatename" ] && echo "Option -t is mandatory. Name the new template" && return 1

  # restrict action if a template exists by that name
  (ls $templatepath/$templatename.img &>/dev/null) && echo "Template name already in use. Use another template name" && return 1

  # copy the guest into a template
  cp "$imagepath/$guest.img" "$templatepath/$templatename.img" || return 1
  cp "$configurationpath/$guest.conf" "$templatepath/$templatename.conf" || return 1

  return 0
}
