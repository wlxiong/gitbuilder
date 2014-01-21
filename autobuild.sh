#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"
CI_PATH="build/ci"

while [ "$(ls -A out/pending)" ]; do
    for file in out/pending/*; do
        set -m
        ref=`basename $file`
        # clean up build/
        ./clean-dir.sh $ref
        # run build
        if [ -f $CI_PATH/run-build.sh ]; then
            $CI_PATH/run-build.sh $ref | tee out/log
        else
            echo "cannot find $CI_PATH/run-build.sh" > out/fail/$ref
        fi
        # make archive
        if [ -f out/pass/$ref ]; then
            $CI_PATH/archive-bin.sh $ref
        fi
        rm $file
    done
done
