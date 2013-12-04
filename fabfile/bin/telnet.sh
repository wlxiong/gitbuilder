#!/bin/sh

while true
do
    telnet localhost:9001
    sleep 1s
    telnet localhost:9002
    sleep 1s
done
