#!/bin/bash -x
DIR="$(dirname $0)"
cd "$DIR"

gfs="ssh://autobuilder@10.10.15.20:29418/gfs"
pystubber="git@10.10.15.19:/usr/local/repo/pystubber.git"

rm -rf build/ gfs/ pystubber/
git clone --no-checkout --origin gerrit $gfs build
( cd build/ && git checkout -b dev gerrit/dev )
git clone --no-checkout --origin gerrit $gfs gfs
( cd gfs/ && git checkout -b dev gerrit/dev )
git clone $pystubber pystubber
