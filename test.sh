#!/bin/bash
DIR=$(dirname $0)

# run unit test
make -C build/testcases/unit ut > out/test/tmp/unit_test_log || exit 3

# run ci test
cd "$DIR/ci-tests"
PYTHONPATH=$PYTHONPATH:../gfs/testcases/stubbercase/autodeploy ./func_test.py 600 2> ../out/test/tmp/setup_error || exit 1
exit 0
