#!/bin/bash

# create an encrypted virtual root disk for a guest to install onto

encrypted_create () {
    if [ ! -e /home/m/guest/conf/"$guest".conf ]; then
            cp /home/m/guest/skel/guest.conf /home/m/guest/conf/"$guest".conf
    fi

    if [ -e /home/m/guest/img/"$guest".img ]; then
        echo "error: $guest.img already exists"
	return
    fi

    qemu-img create -f qcow2 -o "encryption=on" /home/m/guest/img/"$guest"-new.img "$size"
} #1>> "$log" 2>> "$error"
