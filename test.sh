#!/bin/bash
DIR=$(dirname $0)
cd "$DIR/fabfile"

ref="$1"

./stop_all.sh &&
./install_all.sh &&
./start_all.sh &&

# run test
timeout 600 ./run_test.sh
./stop_all.sh

# save test results
mkdir -p ../out/test/$ref/
cp -r /home/root1/gfstest/result/* ../out/test/$ref/
mv -v ../out/log ../out/test/$ref/
exit 0
