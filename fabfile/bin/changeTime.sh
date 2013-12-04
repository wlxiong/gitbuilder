#!/bin/sh

for i in `seq 20`
do
    date -s `date  -d"-600 seconds ago" | awk '{print $4}'`
    sleep 5
done
