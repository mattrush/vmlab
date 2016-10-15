#!/bin/bash

destroy () {
  # save guest's uuid so we can pass it to log_event()
  [ -e "$trashpath/$guest.conf" ] && source $trashpath/$guest.conf
  saveuuid=$uuid
  
  #  if the guest is in the trash, delete it
  [ ! -e $trashpath/?(new.)$guest.img ] && echo "Guest is not in trash. Remove first" && return 1
  rm -f $trashpath/?(*)$guest.{img,conf}
}
