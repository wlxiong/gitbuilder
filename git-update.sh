#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"

( cd build &&
  ../timeout.sh 60 git fetch gerrit )
