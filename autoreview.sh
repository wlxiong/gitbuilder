#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"

while [ "$(ls -A out/pending)" ]; do
    for file in out/pending/*; do
        set -m
        ref=`basename $file`
        ./clean-dir.sh $ref
        ./build/ci/run.sh $file
        rm $file
    done
done
