#!/bin/bash

# show running guests
guests () {
	ps aux | grep qemu | grep -v grep | grep "$guest"
}
