#!/bin/bash

while read line; do
  length=$(echo "$line" |grep Content-Length |awk '{print $2}')

done
