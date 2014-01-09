#!/bin/bash -x
DIR="$(dirname $0)"
cd "$DIR"

ref=$1
msg=$2

build="FAIL"
[ -f out/pass/$ref ] && build="PASS"
tests="FAIL"
[ -f out/test/$ref/PASS ] && tests="PASS"

if [ $build == "PASS" -a $tests == "PASS" ]; then
    score="+1"
else
    score="-1"
fi

url="http://10.10.200.116"
message="\"
 CI results:
 $msg
 Build status: $build (log: $url/autobuilder/log.cgi?log=$ref)
 Test status: $tests (log: $url/test-log/$ref/)\""
ssh -p 29418 autobuilder@10.10.15.20 gerrit review --project gfs --verified $score --message "$message" $ref
