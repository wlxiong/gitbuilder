#!/bin/sh

FILEPATH=/usr/local/gfs/bin
cd $FILEPATH

FILENAME=${FILEPATH}/gfs_master_logger
pid=`ps -ef | grep "$FILENAME -d" | grep -v grep  | awk '{print $2}'`
pidnum=`echo $pid | wc | awk '{print $2}'`
if [ $pidnum -ne 0 ]; then
        echo "kill $pid"
        kill -9 $pid
fi