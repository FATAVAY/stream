#!/usr/bin/env bash

case $1 in
    2k | 4k | 8k)
        input="../video/$1.mp4"
        opt1="-re -stream_loop -3"
        ;;
    c1)
        input=rtsp://admin:fatavay1@192.168.10.51:554/h264/ch1/main/av_stream 
        opt1=
        ;;
    c2)
        input=rtsp://admin:CFBYGQ@192.168.10.52:554/h264/ch1/main/av_stream
        opt1=
        ;;
esac

ffmpeg \
    $opt1 \
    -hwaccel cuda \
	-i $input \
	-c copy -f hls  -hls_time 1.0 -hls_list_size 2 \
	../hls/$1.m3u8 \
	-fflags +igndts \
	-c copy \
    -f rtsp -rtsp_transport tcp rtsp://127.0.0.1:$2/rtsp/$1.live 
