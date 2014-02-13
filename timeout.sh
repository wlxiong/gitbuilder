#!/bin/bash

timeout=`which timeout 2>/dev/null`
if [ -f "$timeout" ]; then
    $timeout $@
else
    ( cmdpid=$BASHPID; (sleep $1; kill $cmdpid) & exec "${@:2}" )
    exit 0
fi
