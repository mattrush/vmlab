#!/bin/bash

# restore a removed guest
unremove () {
  # save guest's uuid so we can pass it to log_event()
  [ -e "$trashpath/$guest.conf" ] && source $trashpath/$guest.conf
  saveuuid=$uuid

  # check that removed guest still exists in the trash
  if [ ! -e $trashpath/?(new.)$guest.img ]; then
    # grep logs for evidence the guest may have existed
    found=$(date -d @$(grep "$guest" $log |grep destroy | cut -d : -f 1) 2> /dev/null)
    if [ -n "$found" ]; then
      echo Guest not in trash. A guest by that name was deleted at $found. #Grep logs manually by uuid
    else
      echo "Guest not found. No record of deletion"
    fi
    return 1
  fi

  # move guest files out of trash, back into service
  mv -v $trashpath/?(new.)$guest.img "$imagepath/"
  mv -v $trashpath/?(.*)$guest.conf "$configurationpath/"
}
