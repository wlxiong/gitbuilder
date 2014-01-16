#!/bin/bash -x
DIR="$(dirname $0)"
cd "$DIR"

ref=$1
astyle_msg=$2

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
 $astyle_msg
 Build status: $build (log: $url/autobuilder/log.cgi?log=$ref)
 Test status: $tests (log: $url/test-log/$ref/)
 Download binary: $url/nightly-build/gfs-bin-${ref:0:7}.tar.gz\""
echo $message
