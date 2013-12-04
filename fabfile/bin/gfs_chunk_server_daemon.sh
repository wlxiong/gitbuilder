#!/bin/sh

send_mail()
{
	subject=$1
	message=$2
	#/usr/local/bin/sendEmail -s mail.xunlei.com -xu 'monitor@xunlei.com' -xp 121212 -f monitor@xunlei.com -t chenxiaodong@xunlei.com -u "$subject" -m "$message"
	/usr/local/bin/sendEmail -s mail.xunlei.com -xu 'monitor@xunlei.com' -xp 121212 -f monitor@xunlei.com -t wangpengyun@xunlei.com -t chenxiaodong@xunlei.com -t hezhijie@xunlei.com -t lx_alarm@xunlei.com -u "$subject" -m "$message"
}

export GFS_SOURCE_PATH=/usr/local/gfs/
export XFS_SOURCE_PATH=/usr/local/gfs/
export LIB_SOURCE_PATH=/usr/local/gfs/lib/
export GFS_HOME=/usr/local/gfs

FILEPATH=/usr/local/gfs/bin
cd $FILEPATH

FILENAME=${FILEPATH}/chunk_server
pid=`ps -ef | grep $FILENAME | grep -v grep  | awk '{print $2}'`

pidnum=`echo $pid | wc | awk '{print $2}'`

if [ $pidnum -ne 0 ]; then
        echo `date`>> ${FILEPATH}/daemon.log
        echo "$FILENAME is running" >> ${FILEPATH}/daemon.log
else
        ulimit -c unlimited
	mkdir -p ${GFS_HOME}/log
	mkdir -p ${GFS_HOME}/stat
	mkdir -p ${GFS_HOME}/pid
        ${FILENAME} -d 
        echo `date` >> ${FILEPATH}/daemon.log
        echo "chunk_server restart.">> ${FILEPATH}/daemon.log
	#send_mail "lixian.gfs WARN $HOSTNAME chunk_server restart " "`date`"
fi

