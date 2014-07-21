#!/bin/bash

timeout=`which timeout 2>/dev/null`
if [ -f "$timeout" ]; then
    $timeout $@
else
    ( cmdpid=$$; (sleep $1; kill -9 $cmdpid) & exec "${@:2}" )
    exit 0
fi
