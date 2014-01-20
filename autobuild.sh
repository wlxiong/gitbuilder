#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"
CI_PATH="build/ci"

while [ "$(ls -A out/pending)" ]; do
    for file in out/pending/*; do
        set -m
        ref=`basename $file`
        ./clean-dir.sh $ref
        # run build
        $CI_PATH/run-build.sh $ref | tee out/log
        # make archive
        if [ -f out/pass/$ref ]; then
            $CI_PATH/archive-bin.sh $ref
        fi
        rm $file
    done
done
