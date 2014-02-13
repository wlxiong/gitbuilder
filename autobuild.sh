#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"
source env.sh

CI_PATH="build/ci"
while [ "$(ls -A out/pending)" ]; do
    for file in out/pending/*; do
        set -m
        ref=`basename $file`
        # clean up build/
        ./clean-dir.sh $ref
        # run build
        build_script=$CI_PATH/run-build.sh
        if [ -f "$build_script" ]; then
            $build_script $ref | tee out/log | tee out/build_log
        else
            echo "cannot find $build_script" > out/fail/$ref
        fi
        rm $file
        echo "No build is running." > build_log
    done
done
