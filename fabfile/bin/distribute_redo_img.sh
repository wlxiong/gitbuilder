#!/bin/bash

distribute_redo_img()
{
    echo "in distribute redo log:"
    curdir=`pwd`
    redo_img_dir="/usr/local/gfs/redo_log/"

    cd $redo_img_dir

    ds1=`date +%Y-%m-%d -d"1 days ago"`
    test -d $ds1 || mkdir $ds1

    ls $redo_img_dir | grep "img_[0-9]\{1,\}$" | while read l
    do
        # 取 修改时间 在1天之前的log文件，压缩同步
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

distribute_redo_img

