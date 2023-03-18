#!/usr/bin/env bash
#-----------------------------------------------------------------------------------
# This script is to:
#   1. generate video stream through ffmpeg
#
# Author: Hao Feng (F1)
#
# Init Date:   Dec. 15, 2022
# Last Date:   Mar. 18, 2023
#
# Copyright (c) 2022-, FATAVAY CO., LTD.

#-----------------------------------------------------------------------------------

os=`uname`

#---
stream=$1
rtsp_p=$2
rtmp_p=$3
i_save=$4

#---
encoder="-vcodec libx264 "

opti=

optg="-strict experimental \
      -c copy \
      -preset veryfast \
      -sc_threshold 0 \
      -flags +cgop \
      -fflags +igndts "

opt_hls="-f hls  \
    -hls_time 2 \
    -hls_playlist_type event \
    -hls_list_size 4 \
    -hls_flags delete_segments \
    -segment_wrap 10 \
    -hls_segment_filename ../hls/${stream}_%09d.ts \
    ../hls/$stream.m3u8 "

#---
if [[ ${i_save} == "true" ]]; then
    save="-strict -2 -ar 22050 ../save/$stream.flv"
else
    save=" "
fi

case $stream in
    2k | 4k | 8k | bd | fight)
        input="../video/$stream.mp4"
        opti="-re -stream_loop -3"

        if [[ $os == 'Linux' ]]; then
            opti="$opti -hwaccel cuda"
            encoder="$encoder -c:v h264_nvenc"
        fi
        ;;
    c1)
        input=rtsp://admin:fatavay1@192.168.10.51:554/h264/ch1/main/av_stream 
        opti=" "
        ;;
    c2)
#       input=rtsp://admin:CFBYGQ@192.168.10.52:554/h264/ch1/main/av_stream
        input=rtsp://admin:CFBYGQ@192.168.21.189:554/h264/ch1/main/av_stream
        opti=" "
        ;;
esac

#---
ffmpeg \
    $opti \
	-i $input \
    \
    $optg \
    \
    $opt_hls \
    \
    $save \
    \
    $encoder \
    \
    -f rtsp -rtsp_transport tcp rtsp://127.0.0.1:${rtsp_p}/rtsp/$stream.live  
#   -f flv rtmp://127.0.0.1:${rtmp_p}/rtmp/$stream.live 
