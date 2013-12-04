#!/bin/bash
DIR=$(dirname $0)
cd "$DIR"

# setup gfs
fab clean_install_dir
fab setup_install_dir
fab install_master
fab install_shadow
fab install_logger
fab install_chunk
fab install_client
fab install_tester
