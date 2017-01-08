#!/bin/bash

lab_instantiatie () {
LAB_NAME="webscale"
templatepath="centos-6.4"
while read i; do
	vm $templatepath instantiate $i; 
done < /home/m/guest/lab/$LAB_NAME.lab
}
