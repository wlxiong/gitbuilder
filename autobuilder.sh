#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"

while [ "$(ls -A out/pending)" ]; do
    for file in out/pending/*; do
        set -m
        ref=`basename $file`
        # check code style
        astyle_msg=$(./check_format.sh $ref)
        if [ $? == 0 ]; then
            # run build
            ./run-build.sh $ref | tee out/log
            # run test
            if [ -f out/pass/$ref ]; then
                ./archive-bin.sh $ref
                ./run-test.sh $ref | tee out/log
            fi
        fi
        # submit review
        submitter=$(cat $file)
        if [ $submitter == "gerrit" ]; then
            ./submit-review.sh $ref "$astyle_msg"
        fi
        rm $file
    done
done
