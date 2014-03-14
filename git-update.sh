#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"

( cd build &&
  git fetch gerrit )
