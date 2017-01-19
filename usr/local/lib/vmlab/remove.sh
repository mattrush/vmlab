#!/bin/bash

# move a guest to the trash. deleted weekly via cron
remove () {

  function toTrash () {
    # move guest files to trash to await deletion
    mv -v "$imagepath/?(new.)$guest.img" "$trashpath/$lab/" &>/dev/null
    mv -v "$configurationpath/?(.*)$guest.conf" "$trashpath/$lab/" &>/dev/null
  }

  # restrict action by run state
  [ -n "$runflag" ] && echo "Guest is running. Halt first" && return 1	

  # make sure there's a guest to remove, old or new
  [ ! -e ${imagepath}/?(new.)${guest}.img ] && echo "Guest does not exist" && return 1

  # if the guest is part of a lab, place the guest .img and .conf with the lab folder in the $remove directory, and if there are no other guests in the same lab, remove the lab directories under /etc/vmlab/conf and /vmlab-data.
  if [[ $guest =~ / ]]; then
    lab="$(echo $guest |rev |cut -d / -f2- |rev)"

    mkdir -p $trashpath/$lab
    toTrash

    count=$(find $configurationpath/$lab $imagepath/$lab \! -name ".*" |wc -l)
    if [[ $count -eq 2 ]]; then 
      rm -rf $configurationpath/$lab $imagepath/$lab
    fi
    exit    
  fi

  toTrash
  #mv -v $imagepath/?(new.)$guest.img "$trashpath/" > /dev/null 2>&1
  #mv -v $configurationpath/?(.*)$guest.conf "$trashpath/" > /dev/null 2>&1
 }
