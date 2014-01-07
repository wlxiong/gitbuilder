#!/bin/bash
DIR=$(dirname $0)
cd "$DIR/ci-tests"

PYTHONPATH=$PYTHONPATH:../gfs/testcases/stubbercase/autodeploy ./func_test.py 600 && exit 0

exit 1
