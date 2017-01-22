#!/bin/bash

kill_usage () {
usage: $0 options

OPTIONS:
  -h	Show this message
  -v	Verbose output
  -f	Force repid before kill
EOF
}

# ungracefully stop a guest (kill and clean)
kill_ () {
  # restrict action by run state
  [ -z "$runflag" ] && echo "Guest is halted. Boot first" && return 1	

  # handle options
  while getopts ":hvf" opt; do
    case $opt in
      h)
        kill_usage
        return 0
        ;;
      v)
        verboseflag=1
        ;;
      f)
        (vmlab ?(new.)$guest repid)
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
  # test for a pidfile
  [ ! -e "$pidfile" ] && echo "No pidfile exists for guest. Use repid first or kill -f" && return 1

  # only remove the guest's chroot and pidfile if kill succeeds.
  kill $(cat "$pidfile")
  rm "$pidfile" && rm -rf "$chroot"
}
