#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"

ref=$1

build="FAIL"
[ -f out/pass/$ref ] && build="PASS"
tests="FAIL"
[ -f out/test/$ref/PASS ] && tests="PASS"

if [ $build == "PASS" -a $tests == "PASS" ]; then
    score="+1"
else
    score="-1"

url="http://10.10.200.115/gitbuilder"
message="Build status: $build (log: $url/log.cgi?log=$ref)    Test status: $tests (log: $url/test/$ref/)"
ssh -p 29418 admin@10.10.15.20 gerrit review --project gfs --verified $score --message '"$message"' $ref
