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
        # run ci build and test
        review_script=$CI_PATH/run-review.sh
        if [ -f "$review_script" ]; then
            $review_script $file | tee out/autobuilder.log
        else
            echo "cannot find $review_script" > out/fail/$ref
        fi
        rm $file
        echo "No build is running." > tee out/autobuilder.log
    done
done
