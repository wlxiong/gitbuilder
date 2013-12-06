#!/bin/bash
DIR=$(dirname $0)
cd "$DIR/fabfile"

./stop_all.sh &&
./install_all.sh &&
./start_all.sh &&
./run_test.sh
./stop_all.sh

exit 0
