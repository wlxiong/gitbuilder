#!/bin/bash
DIR=$(dirname $0)
cd "$DIR"

# stop gfs
fab stop_master
fab stop_shadow
fab stop_logger
fab stop_chunk
