#!/bin/sh

for i in $(seq 1000)
do
    ./kill_logger.sh
    sleep 90s
    ./start_logger.sh 
    sleep 90s
done
