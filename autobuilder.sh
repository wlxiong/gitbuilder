#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"

while [ "$(ls -A out/pending)" ]; do
    for ref in out/pending/*; do
        set -m
        ./run-build.sh $ref | tee out/log &
        XPID=$!
        trap "echo 'Killing (SIGINT)';  kill -TERM -$XPID; exit 1" SIGINT
        trap "echo 'Killing (SIGTERM)'; kill -TERM -$XPID; exit 1" SIGTERM
        wait; wait
        rm out/pending/$ref
    done
done
