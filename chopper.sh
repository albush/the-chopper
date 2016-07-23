#!/bin/bash

# a little utility to cut an mp4 into smaller clips based on timestamps.
filename=$1
cut_list=$2
out_path=$3
container=$4

# does the output directory exist?
  if [ ! -d "$out_path" ]; then
    while true; do
      read -p "Oh noes, that directory isn't there. should I create $out_path for you?" yn
      case $yn in
          [Yy]* ) mkdir $out_path; break;;
          [Nn]* ) echo "Ok. I'll be here if you want to try again."; exit;;
          * ) echo "Please answer yes or no.";;
      esac
    done
  fi
# read in a csv, use those values to create individual files via ffmpeg.
# Check to see if the video exists
if [[ -f "$filename" ]]
  then
# now check to see if the cut_list exists
    echo "Video......... Check!"
    if [[ -f "$cut_list" ]]
# The cut list exists, let's chop it up.
      then
        echo "Cut List........ Check!"
# chop the videos
        chop-vids.sh $filename $cut_list $out_path
# if the cut list does not exist, exit.
      else echo "That cut list doesn't exist. Try again"
        exit
    fi
# if the cut video does not exist, exit.
  else echo "That video doesn't exist. Try again"
    exit
fi

if [ ! -z "$4" ]
  then
    echo chop-export.sh $out_path $container
  else
    echo "I guess we're not exporting those videos, afterall."
fi
