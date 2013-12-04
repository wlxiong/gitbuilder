#!/bin/bash

distribute_redo_log()
{
    echo "in distribute redo log:"
    curdir=`pwd`
    redo_log_dir="/usr/local/gfs/redo_log/"

    cd $redo_log_dir

    ds1=`date +%Y-%m-%d -d"1 days ago"`
    test -d $ds1 || mkdir $ds1

    ls $redo_log_dir | grep "^img_[0-9]\{1,\}$" | while read l
    do
        # 取修改时间在1天之前的 img 文件，压缩同步
        ds2=`stat $l | grep "Modify:" | awk '{print $2}'`
        echo $ds1 $ds2
        if [ $ds1 == $ds2 ]
        then
            bzip2 -zk $l
            mv $l.bz2 $ds1
        fi 
    done
    
    ls $redo_log_dir | grep "^log_[0-9]\{1,\}$" | while read l
    do
        # 取修改时间在1天之前的 log 文件，压缩同步
        ds2=`stat $l | grep "Modify:" | awk '{print $2}'`
        echo $ds1 $ds2
        if [ $ds1 == $ds2 ]
        then
            bzip2 -zk $l
            mv $l.bz2 $ds1
        fi 
    done

    # remove old data
    ds2=`date +%Y-%m-%d -d"2 days ago"`
    test -d $ds2 && rm -rf $ds2

    cd $curdir
}

distribute_redo_log


ds1=`date +%Y-%m-%d -d"1 days ago"`
sdir="/usr/local/gfs"
h=`hostname | sed 's/..$//'`
/usr/bin/rsync -avzP --password-file="$sdir/bin/master_log_rsync/rsyncd.secrets" \
        $sdir/redo_log/${ds1} \
        xlvip@twin05a06.sandai.net::gfs_master_log/redo_log_cxx/${h}

