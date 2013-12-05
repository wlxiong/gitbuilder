#!/bin/bash
DIR=$(dirname $0)
cd "$DIR/fabfile"

ref="$1"

./stop_all.sh &&
./install_all.sh &&
./start_all.sh &&
timeout 600 ./run_test.sh
# clean up
./stop_all.sh
cp -r /home/root1/gfstest/result/* ../out/test/$ref/
mv -v out/log ../out/test/$ref/
exit 0
