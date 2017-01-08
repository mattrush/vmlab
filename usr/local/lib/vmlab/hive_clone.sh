##qemu-img create -b base/vanilla-14.0-redmine.img  -f qcow2 clone/infosec.qcow2


#!/bin/bash

# clone a "high density" instance

## if the image is a clone, resolve it's name
#TEST_CLONE=`echo "$guest" | grep "/"`
#if [ -n "$TEST_CLONE" ]; then
#    guest=`echo "$guest" | cut -d/ -f2- `
#fi
