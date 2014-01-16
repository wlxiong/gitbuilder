#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"

$ref=$1

# check code style
./check_format.sh $ref | tee out/log
if [ $? == 0 ]; then
    # run build
    ./run-build.sh $ref | tee out/log
    # run test
    if [ -f out/pass/$ref ]; then
        ./archive-bin.sh $ref
        ./run-test.sh $ref | tee out/log
    fi
fi
