#!/usr/bin/env bash

time=$1
remain=$2
streams=($@)

while true
do
    sleep $time

    for s in ${streams[@]}; do
        file=(`ls ../hls/${s}*ts`)
        num=${#file[@]}

        for (( i=0; i < ${num} - $remain; i++ ))
        do
            rm ${file[$i]}
        done
    done
done
   
