#!/bin/sh
# �����˽ű����� master ���ڻ�������

# 1. ��� gfs chunk ���Ƿ�ӽ�����, ʹ���ʴﵽ97%��ʱ�򷢱����ʼ�
now_percent=` /usr/local/bin/gfs -df | grep "chunks used" | awk '{print $NF}' | awk -F / '{printf("%d",$1*100/$2)}'`
#echo $now_percent
if [ ${now_percent} -ge 90 ]
then
        title="$HOSTNAME GFS Full Warning [`date +"%Y-%m-%d %H:%M:%S"`] cur_percent=[${now_percent}%]"
        msg=`echo hello;/usr/local/bin/gfs -df | head -n 15;`
        echo $title
        /usr/local/bin/sendEmail -s mail.cc.sandai.net -xu 'monitor@cc.sandai.net' -xp 121212 -f monitor@cc.sandai.net -t gfsdev@xunlei.com -t lx_alarm@xunlei.com -u "${title}" -m "${msg}"
fi


# 2. ���gfs ��ǰ�ļ������Ƿ�ӽ����õ�����ļ������ﵽ97%ʱ����
suffix=`date +%s%N`
cp -f /usr/local/gfs/conf/master.conf /usr/local/gfs/conf/master.conf.backup.$suffix
dos2unix -q /usr/local/gfs/conf/master.conf.backup.$suffix
max_file_num=`grep -P -o "^\s*max_file_num\s*=\s*[0-9]*[^#]" /usr/local/gfs/conf/master.conf.backup.$suffix | grep -o "[1-9][0-9]*"`
rm -f /usr/local/gfs/conf/master.conf.backup.$suffix
cur_file_num=`/usr/local/bin/gfs -df | head -n 2 | tail -n 1 | awk '{print $2}'`

file_num_rate=$(( $cur_file_num * 100 / $max_file_num))
#echo $file_num_rate
if [ $file_num_rate -ge 90 ]
then
    title="$HOSTNAME GFS Filenum Warning [`date +"%Y-%m-%d %H:%M:%S"`] cur_percent=[${file_num_rate}%]"
    msg="[$HOSTNAME] filenum is reaching the limit. max_file_num:[$max_file_num], cur_file_num:[$cur_file_num]"
    echo $title
    /usr/local/bin/sendEmail -s mail.cc.sandai.net -xu 'monitor@cc.sandai.net' -xp 121212 -f monitor@cc.sandai.net -t gfsdev@xunlei.com -t lx_alarm@xunlei.com -u $title -m $msg
fi


