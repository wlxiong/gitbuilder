#!/bin/sh
for i in `seq 100`
do
    killall -9 gfs_master >/dev/null 2>&1
    sleep 5
    rm -f `ls -l -t ../redo_log/img_* | awk {'print $NF'}  | sed -n '1,2p'`
    sleep 5
    ./daemo_gfs_master.sh
    sleep 600
done
