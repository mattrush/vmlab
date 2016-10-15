#!/bin/bash
shopt -s extglob dotglob || exit 1
. /etc/guestrc/host.conf || exit 1

# remove temp files
echo "Deleting vim temp files from manual edits to guest configuration files..."
#looseends=( $(ls $configurationpath/?(*~)) )
#for i in "${looseends[@]}"; do
#  rm $i
#done
rm /etc/guestrc/conf/!(*.conf)
echo -e "\n"

# remove leftovers
echo "Deleting stray files in $configurationpath"
guestlist+=( $(ls $imagepath/*.img |cut -d / -f 3 |rev |cut -d . -f -2 |rev |cut -d . -f 1) )
  guestlist=( $(echo "${guestlist[@]}" |tr ' ' '\n' |sort |uniq) )
  ##echo "${guestlist[@]}" #DEBUG output

conflist+=( $(ls $configurationpath/?(*).conf |cut -d / -f 5 |rev |cut -d . -f -2 |rev |cut -d . -f 1) )
  conflist=( $(echo "${conflist[@]}" | tr ' ' '\n' |sort |uniq |grep -v 'SKEL') )
  ##echo "${conflist[@]}" #DEBUG output

for i in "${conflist[@]}"; do
  unset skip
  c=${#guestlist[@]}
  until [ $c == 0 ]; do
    ((c--))
    [ "${guestlist[$c]}" == "$i" ] && skip=1 && break
  done
  [ -n "$skip" ] && continue
  conflist=( "${conflist[@]/$i}" ) && mv $configurationpath/?(*.)$i.conf /var/vmlab/trash/
done

# burn the trash
echo "Destroying guests in trash..."
deadmeat=( $(ls $trashpath/?(*).img) )
for i in "${deadmeat[@]}"; do
  i=$(echo $i |cut -d. -f -1 |rev |cut -d/ -f -1 |rev)
  vmlab "$i" destroy
done
echo -e "\n"

#Delete everything else in the trash
#rm -rf $trashpath/?(*)
