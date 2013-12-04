#!/bin/sh

FILEPATH=/usr/local/gfs/bin
cd $FILEPATH

FILENAME=${FILEPATH}/chunk_server
pid=`ps -ef | grep $FILENAME | grep -v grep  | awk '{print $2}'`
pidnum=`echo $pid | wc | awk '{print $2}'`
if [ $pidnum -ne 0 ]; then
        echo "kill $pid"
        kill -9 $pid
fi
