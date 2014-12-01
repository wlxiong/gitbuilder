#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"
source env.sh

run_script() {
    script=$1
    ref=$2
    timeout=$3
    # clean up build/
    ./clean-dir.sh $ref
    # run build
    if [ -f "$script" ]; then
        ./maxtime $timeout $script $ref | tee out/log | tee build_log
    else
        echo "cannot find $script" > out/fail/$ref
    fi

    echo "No build is running." > build_log
}

while [ "$(ls -A out/pending)" ]; do
    for file in out/pending/*; do
        set -m
        ref=`basename $file`
        action=`cat $file | awk '{ print $4 }'`
        echo "`date +"%Y-%m-%d %T"` run HEAD $ref: $action" >> $DIR/event_log
        [ "$action" = "build" ]  && run_script build/ci/run-build.sh $ref $TIMEOUT
        [ "$action" = "review" ] && run_script build/ci/run-review.sh $ref $TIMEOUT
        rm -f $file
    done
done
