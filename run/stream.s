#!/usr/bin/env bash

os=`uname`

if [[ $os == 'Darwin' ]]; then
    opt2=" "
else
    opt2="-c:v h264_nvenc"
fi
os=`uname`

if [[ $os == 'Darwin' ]]; then
    opt2=" "
else
    opt2="-c:v h264_nvenc"
fi

case $1 in
    2k | 4k | 8k | bd)
        input="../video/$1.mp4"
        opt1="-re -stream_loop -3"
        ;;
    c1)
        input=rtsp://admin:fatavay1@192.168.10.51:554/h264/ch1/main/av_stream 
        opt1=""
        ;;
    c2)
        input=rtsp://admin:CFBYGQ@192.168.10.52:554/h264/ch1/main/av_stream
        opt1="-r 10"
        ;;
esac

ffmpeg \
    $opt1 \
    -hwaccel cuda \
	-i $input \
    \
    -preset veryfast -c copy \
    -f hls  \
    -hls_init_time 1 \
    -hls_time 1 \
    -hls_list_size 1 \
    -hls_wrap 2 \
    -hls_playlist_type event \
	../hls/$1.m3u8 \
    \
	-fflags +igndts \
	-c copy \
	$opt2 \
    -f rtsp -rtsp_transport tcp rtsp://127.0.0.1:$2/rtsp/$1.live  

#    -preset veryfast -c copy -f hls  -hls_time 1 -hls_list_size 0 \
