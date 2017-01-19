#!/bin/sh

name="vmlab"
ver="0.1.8.1"
arch="noarch"
plvl="0"
tag="mrush"
pkg="${name}-${ver}-${arch}-${plvl}_${tag}"
dest="/var/www/htdocs/mirror/slack/slackware-packages"

mkdir "$dest/$pkg"
#find . -type d -maxdepth 1 -mindepth 1 \! -name ".git*" |xargs -I% cp -vR % ../$pkg
find . -type d -maxdepth 1 -mindepth 1 \! -name ".git*" -exec cp -vR {} $dest/$pkg \;
makepkg -c y $dest/$pkg.txz
rm -rf $dest/$pkg
