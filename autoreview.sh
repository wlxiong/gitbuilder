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
        # run ci build and test
        if [ -f $CI_PATH/run.sh ]; then
            $CI_PATH/run.sh $file
        else
            echo "cannot find $CI_PATH/run.sh" > out/fail/$ref
        fi
        rm $file
    done
done
