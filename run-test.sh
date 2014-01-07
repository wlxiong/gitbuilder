#!/bin/bash
DIR=$(dirname $0)
cd "$DIR"

if [ -z "$1" ]; then
    echo "Usage: $0 <commitid>" >&2
    echo "  Test the tree in build/ as of the given commitid."
    exit 1
fi

ref="$1"

mkdir -p out/test/tmp/
mkdir -p out/test/$ref/
rm -rf out/test/$ref/*
touch out/test/$ref/TEST_IS_RUNNING

./test.sh $ref 2>&1
ret=$?

rm -f out/test/$ref/TEST_IS_RUNNING
mv -v out/test/tmp/* out/test/$ref/
mv -v out/log out/test/$ref/setup_log

if [ $ret == 0 ]; then
    touch out/test/$ref/PASS
    exit 0
else
    touch out/test/$ref/FAIL
    exit 1
fi
