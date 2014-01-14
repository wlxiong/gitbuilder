#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR/build"

ref=$1

mkdir -p bin/
bins="x_master/gfs_master x_shadow_master/gfs_shadow_master log_server/gfs_master_logger chunk_server/chunk_server sclient/FsShell"
for f in $bins
do
    mv -v $f bin/
done

cd bin/
tar zcf ../../out/nightly/gfs-bin-${ref:0:7}.tar.gz *
