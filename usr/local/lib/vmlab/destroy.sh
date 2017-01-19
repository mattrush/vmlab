#!/bin/bash

destroy () {
  # save guest's uuid so we can pass it to log_event()
  [ -e "$trashpath/$guest.conf" ] && source $trashpath/$guest.conf
  saveuuid=$uuid
  
  if [[ $guest =~ / ]]; then
    lab="$(echo $guest |rev |cut -d / -f2- |rev)"
    gName="$(echo $guest |rev |cut -d / -f1 |rev)"

    # remove from trash
    [ ! -e $trashpath/$lab/?(new.)$gName.img ] && echo "Guest is not in trash. Remove first" && return 1
    rm -f $trashpath/$lab/?(*)$gName.{img,conf}

    # if it's the only guest in the lab directory within the trash, delete the directory as well
    count=$(find $trashpath/$lab \! -name ".*" |wc -l)
    if [[ $count -eq 1 ]]; then
      rm -rf $trashpath/$lab
    fi
  else
    [ ! -e $trashpath/?(new.)$guest.img ] && echo "Guest is not in trash. Remove first" && return 1
    rm -f $trashpath/?(*)$guest.{img,conf}
  fi
}
