#!/bin/bash
DIR=$(dirname $0)
cd "$DIR/ci-test"

./func_test.py 600 && exit 0
