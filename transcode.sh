#!/usr/bin/env bash

INPUT=$1
BITRATE=$2
OUTPUT=$3

ffmpeg -re -i "$INPUT" \
	-c:v libx264 \
	-c:a aac \
	-ac 2 \
	-preset veryfast \
	-tune zerolatency \
	-b:a 160k \
	-ar 44100 \
	-b:v "$BITRATE"k \
	-maxrate "$BITRATE"k \
	-bufsize $((BITRATE * 2))k \
	-x264opts "keyint=60:no-scenecut:nal-hrd=cbr" \
	-profile:v high \
	-level:v 4.0 \
	-pix_fmt yuv420p \
	-r 30 \
	-f flv "$OUTPUT"
