#!/bin/bash

LAB="$1"

while read vm; do 
  vm $vm remove; 
  vm $vm destroy; 
done < lab/$LAB.lab
