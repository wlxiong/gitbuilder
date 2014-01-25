#!/bin/bash -x
DIR="$(dirname $0)"
cd "$DIR"
source env.sh

gfs="ssh://$GERRIT_USER@$GERRIT_IP/gfs"
pystubber="git@10.10.15.19:/usr/local/repo/pystubber.git"

rm -rf build/ pystubber/
git clone --no-checkout --origin gerrit $gfs build
( cd build/ && git checkout dev )
git clone $pystubber pystubber

echo "Please 'cp env.sh.example env.sh' and modify ..."
