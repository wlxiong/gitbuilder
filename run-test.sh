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

mv -v out/test/tmp/* out/test/$ref/
mv -v out/log out/test/$ref/setup_log

exit 0
