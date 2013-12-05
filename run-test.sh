#!/bin/bash
DIR=$(dirname $0)
cd "$DIR"

if [ -z "$1" ]; then
    echo "Usage: $0 <commitid>" >&2
    echo "  Test the tree in build/ as of the given commitid."
    exit 1
fi

ref="$1"

mkdir -p out/test

./test.sh $ref

exit 0
