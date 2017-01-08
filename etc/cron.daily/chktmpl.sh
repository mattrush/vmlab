#!/bin/bash

pushd /cloud-tmpl/ 
for i in `find . -type f -maxdepth 1 -name "*.img"`; do
	[ ! -e $i.md5 ] && md5sum $i > $i.md5
done
popd
