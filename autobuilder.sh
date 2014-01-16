#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"

while [ "$(ls -A out/pending)" ]; do
    for file in out/pending/*; do
        set -m
        ref=`basename $file`
        ./run.sh $ref
        # submit review
        submitter=$(cat $file)
        if [ $submitter == "gerrit" ]; then
            ./submit-review.sh $ref "$astyle_msg"
        fi
        rm $file
    done
done
