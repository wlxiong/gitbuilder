#!/bin/sh

export GFS_HOME=/usr/local/gfs

FILEPATH=${GFS_HOME}/bin
cd $FILEPATH

master_id=`ps -ef | grep "/usr/local/gfs/bin/gfs_master -d" | grep -v "grep" | awk '{print $2}'`
#kill -9 $master_id

FILENAME=${FILEPATH}/gfs_master
#FILENAME=${FILEPATH}/gfs_master_3.4_test
pid=`ps -ef | grep "${FILENAME} " | grep -v grep | grep -v logger  | awk '{print $2}'`
pidnum=`echo $pid | wc | awk '{print $2}'`

#echo $pidnum
#exit
#echo '$pidnum: ' $pidnum >> ${FILEPATH}/daemo.log

if [ $pidnum -ne 0 ]; then
	echo "$FILENAME is running" > /dev/null
else
	ulimit -c unlimited
	ulimit -n 65535
	${FILENAME} -d >> ${FILEPATH}/daemo.log
	echo "master_gfs restart.">> ${FILEPATH}/daemo.log
fi
