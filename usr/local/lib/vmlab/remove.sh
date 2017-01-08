#!/bin/bash

# move a guest to the trash. deleted weekly via cron
remove () {
  # restrict action by run state
  [ -n "$runflag" ] && echo "Guest is running. Halt first" && return 1	

  # make sure there's a guest to remove, old or new
  [ ! -e ${imagepath}/?(new.)${guest}.img ] && echo "Guest does not exist" && return 1

  # move guest files to trash to await deletion
  mv -v $imagepath/?(new.)$guest.img "$trashpath/" > /dev/null 2>&1
  mv -v $configurationpath/?(.*)$guest.conf "$trashpath/" > /dev/null 2>&1
}
