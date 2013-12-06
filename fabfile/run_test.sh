#!/bin/bash
DIR=$(dirname $0)
cd "$DIR"

# start test
fab --command-timeout=600 start_func_test
fab save_test_log
