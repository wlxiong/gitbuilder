#!/bin/bash

( cmdpid=$BASHPID; (sleep $1; kill $cmdpid) & exec "${@:2}" )
