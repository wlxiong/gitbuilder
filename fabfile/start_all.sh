#!/bin/bash
DIR=$(dirname $0)
cd "$DIR"

# start gfs
fab start_chunk
fab start_logger
fab start_shadow
fab start_master
fab start_func_test
