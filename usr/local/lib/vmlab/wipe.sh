#!/bin/bash

wipe () {
  # restrict action by run state
  [ -n "$runflag" ] && echo "Guest is running. Halt first" && return 1	

  >"/$imagepath"/"$guest".img
}
