#!/bin/bash

    if [ -z "$1" ];
    then
    echo "Please enter the file name";
    else
    if [ -z "$2" ];
    then
    meanDB=$(ffmpeg.exe -i "$1" -af "volumedetect" -vn -sn -dn -f null /dev/null 2>&1 | grep mean_volume | awk {'print $5'});
    cutDB=$(awk "BEGIN {print $meanDB-17}");
    ffmpeg.exe -i "$1" -af silenceremove=stop_periods=-1:stop_duration=0.1:stop_threshold="$cutDB"dB "trimmed${cutDB}_$1.mp3";
    ffmpeg.exe -i "$1" 2>&1 | grep Duration;
    ffmpeg.exe -i "trimmed${cutDB}_$1.mp3" 2>&1 | grep Duration;
    else
    ffmpeg.exe -i "$1" -af silenceremove=stop_periods=-1:stop_duration=0.1:stop_threshold=-"$2"dB "trimmed$2_$1";
    ffmpeg.exe -i "$1" 2>&1 | grep Duration;
    ffmpeg.exe -i "trimmed$2_$1.mp3" 2>&1 | grep Duration;
    fi
    fi