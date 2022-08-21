#!/bin/bash

if [[ $# -ne 1 ]] ; then
    echo "Usage: $0 music_file"
    exit 0
fi

# ffmpeg parameters
VBR="2000k"
FPS="30"
QUAL="veryfast"
THREADS="4"
CRF="32"

# Stream parameters
STREAM_URL="rtmp://localhost/live/"
KEY="test"

# File parameters
BG_IMAGE="./courtroom.png"
TITLE_FONT="./fonts/JF-Dot-K14.ttf"
PLAYTIME_FONT="./fonts/Igiari.ttf"

SOURCE=$1
COVER=$(dirname "$1")/Folder.jpg

# Get a random character picture
PIC=$(shuf imgList.txt | head -n 1)
# Apply different flags depending on whether the picture is a gif or not
if [[ ${PIC: -3} = "gif" ]]; then
    PIC_FLAGS="-ignore_loop 0"
else
    PIC_FLAGS="-loop 1"
fi

echo "Playing $1..."

duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$SOURCE")
stream_duration=$(awk "BEGIN{print $duration - 0.2}") # Stream duration is slightly shorter than actual song duration to minimize interruptions
title=$(ffprobe -v error -show_entries format_tags=title -of default=noprint_wrappers=1:nokey=1 "$SOURCE")
# Change characters that cause parsing problems to lookalike characters - I'm too lazy to properly escape these.
title=${title//\~/～}
title=${title//\:/：}
title=${title//\'/’}

convert "$COVER" -resize 300x300 cover.jpg # Resize ahead of time and to fixed filename to avoid headaches

ffmpeg -hide_banner -loglevel error \
    -loop 1 -i $BG_IMAGE \
    -re -i "$SOURCE" \
    -loop 1 -i cover.jpg \
    $PIC_FLAGS -i "$PIC" \
    -map "[a]" \
    -deinterlace -filter_complex \
    "[1:a]volume=0.7[a]; \
    [0]crop=1280:720[bg]; \
    [bg]drawbox=y=0: x=799: w=481: h=90: color=black@0.6: t=fill[bg]; \
    \
    color=c=black@0.0:s=390x40[title]; \
    [title]drawtext=fontfile=$TITLE_FONT: \
    text='$title': fontcolor=white: fontsize=30: \
    x=if(gt(text_w\, w) \,\
        if(gt(mod(20*t\,text_w-w+100)\, text_w-w+40) \,\
            0 \,\
            if(gt(mod(20*t\,text_w-w+100)\, text_w-w) \,\
                -(text_w-w) \,\
                -mod(20*t\,text_w-w+100) \
            ) \
        ) \,\
        w-text_w \
    ): y=5[title]; \
    \
    [bg]drawtext=fontfile=$PLAYTIME_FONT: \
    text='%{eif\:(t/60)\:d\:2}\:%{eif\:mod(t,60)\:d\:2} / %{eif\:($duration/60)\:d\:2}\:%{eif\:mod($duration,60)\:d\:2}':\
    fontcolor=white: fontsize=30: x=(w-text_w-5): y=40[bg]; \
    \
    color=c=white@0.4:s=400x10[bar_empty]; \
    color=c=red:s=400x10[bar]; \
    \
    [1:a]showfreqs=s=20x20:colors=#EEEEEE #EEEEEE:mode=bar[spect]; \
    [spect]scale=w=80:h=80:interl=-1:flags=neighbor[spect]; \
    [bg][spect]overlay=799:10:shortest=1[bg]; \
    \
    [bg][title]overlay=885:0:shortest=1[bg]; \
    [bar_empty][bar]overlay=-w+(w/$duration)*t:H-h:shortest=1[bar_empty]; \
    [bg][bar_empty]overlay=880:80:shortest=1[bg]; \
    [bg][3]overlay=(W-w)/2:(H-h):shortest=0[bg]; \
    [bg][2]overlay=(W-w):90:shortest=1" \
    -vcodec libx264 -pix_fmt yuv420p -preset $QUAL -tune zerolatency -r $FPS -g $(($FPS * 2)) -b:v $VBR \
    -ar 44100 -threads $THREADS -crf $CRF -maxrate 2000k -b:a 192k -bufsize 4096k \
    -shortest -t $stream_duration -f flv "$STREAM_URL$KEY"

echo
