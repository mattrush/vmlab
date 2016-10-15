#!/bin/bash

running () {
  ps aux | grep qemu | grep -v qemu
  NUMBER=`ps aux | grep qemu | grep -v qemu | wc -l`
  echo "$NUMBER guests running"
}
