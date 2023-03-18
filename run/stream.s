#!/usr/bin/env bash

os=`uname`

opt2=" "
#opt3="-strict experimental -c copy -preset veryfast -sc_threshold 0 -flags +cgop"
opt3=

if [[ $4 == "true" ]]; then
    save="-strict -2 ../save/$1.mkv"
else
    save=" "
fi

case $1 in
    2k | 4k | 8k | bd | fight)
        input="../video/$1.mp4"
        opt1="-re -stream_loop -3"

        if [[ $os == 'Linux' ]]; then
            opt1="$opt1 -hwaccel cuda"
#           opt2="-c:v h264_nvenc"
        elif [[ $os == "Darwin" ]]; then
            opt2=
        fi
        ;;
    c1)
        input=rtsp://admin:fatavay1@192.168.10.51:554/h264/ch1/main/av_stream 
        opt1="-r 25"
        ;;
    c2)
#       input=rtsp://admin:CFBYGQ@192.168.10.52:554/h264/ch1/main/av_stream
        input=rtsp://admin:CFBYGQ@192.168.21.189:554/h264/ch1/main/av_stream
        opt1="-r 10"
        ;;
esac
opt2="$opt2 -vcodec libx264 "

ffmpeg \
    $opt1 \
	-i $input \
    \
    $opt3 \
    -f hls  \
    -hls_time 2 \
    -hls_playlist_type event \
    -hls_list_size 4 \
    -hls_flags delete_segments \
    -segment_wrap 10 \
    -hls_segment_filename ../hls/$1_%09d.ts \
	../hls/$1.m3u8 \
    \
	-fflags +igndts \
    $save \
	$opt2 \
    -f rtsp -rtsp_transport tcp rtsp://127.0.0.1:$2/rtsp/$1.live  
#   -f flv rtmp://127.0.0.1:$3/rtmp/$1.live 
