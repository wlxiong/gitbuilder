#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"

while [ "$(ls -A out/pending)" ]; do
    for file in out/pending/*; do
        set -m
        ref=`basename $file`
        ./run-build.sh $ref | tee out/log &
        XPID=$!
        trap "echo 'Killing (SIGINT)';  kill -TERM -$XPID; exit 1" SIGINT
        trap "echo 'Killing (SIGTERM)'; kill -TERM -$XPID; exit 1" SIGTERM
        wait; wait
        ./run-test.sh $ref | tee out/log &
        XPID=$!
        trap "echo 'Killing (SIGINT)';  kill -TERM -$XPID; exit 1" SIGINT
        trap "echo 'Killing (SIGTERM)'; kill -TERM -$XPID; exit 1" SIGTERM
        wait; wait
        rm $file
    done
done
