#!/bin/sh

for i in $(seq 1000)
do
    ./kill_master.sh
    sleep 90s
    ./daemo_gfs_master.sh
    sleep 90s
done
