#!/bin/bash
DIR=$(dirname $0)
cd "$DIR/build"

if [ -x ../branches-local ]; then
    exec ../branches-local "$@"
fi

if [ "$1" = "-v" ]; then
    VERBOSE=1
else
    VERBOSE=
fi

git ls-remote gerrit refs/changes/* |
    tac |
    while read commit change; do
        prev="$curr"
        curr="$change"
        if [ -e ../out/ignore/$commit -o "$prev" = "$change" ]; then
            continue;
        fi
        [ -n "$VERBOSE" ] && echo -n "$commit "
        echo "$change"
    done |
    tac
