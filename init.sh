#!/bin/bash

# Add more file extensions as needed
find -name *.mp3 > playlist.txt
find -name *.flac >> playlist.txt
find -name *.ogg >> playlist.txt
find -name *.aac >> playlist.txt
find -name *.wav >> playlist.txt

find characterPics/* > imgList.txt

echo Initialized radio successfully. Run ./stream_playlist.sh to start it!
