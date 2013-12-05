#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"

while [ "$(ls -A out/pending)" ]; do
    for file in out/pending/*; do
        set -m
        ref=`basename $file`
        ./run-build.sh $ref | tee out/log
        if [ -f out/pass/$ref ]; then
            ./run-test.sh $ref | tee out/log
        fi
        rm $file
    done
done
