#!/bin/sh

tag=mrush
pkgDir="../vmlab-0.1.0_$tag"
mkdir $pkgDir
find . -type d -maxdepth 1 -mindepth 1 \! -name ".git*" |xargs -I% cp -vR % $pkgDir
