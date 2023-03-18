#!/usr/bin/env bash
#-----------------------------------------------------------------------------------
# This script is to:
#   1. clean video hls stream files since they are growing faster
#
# Author: Hao Feng (F1)
#
# Init Date:   Dec. 15, 2022
# Last Date:   Mar. 18, 2023
#
# Copyright (c) 2022-, FATAVAY CO., LTD.

#-----------------------------------------------------------------------------------

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
