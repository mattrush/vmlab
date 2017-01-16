#!/bin/sh

name="vmlab"
ver="0.1.5"
arch="noarch"
plvl="0"
tag="mrush"
pkg="${name}-${ver}-${arch}-${plvl}_${tag}"

mkdir ../$pkg
#find . -type d -maxdepth 1 -mindepth 1 \! -name ".git*" |xargs -I% cp -vR % ../$pkg
find . -type d -maxdepth 1 -mindepth 1 \! -name ".git*" -exec cp -vR {} ../$pkg \;
makepkg -c y ../$pkg.txz
