#!/bin/bash
DIR=$(dirname $0)
cd "$DIR/fabfile"

ref="$1"

./stop_all.sh &&
./install_all.sh &&
./start_all.sh &&
./run_test.sh
./stop_all.sh

# save test results
cp -rv /home/root1/gfstest/result/* ../out/test/$ref/
exit 0
