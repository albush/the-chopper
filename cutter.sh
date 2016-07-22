#!/bin/bash

# a little utility to cut an mp4 into smaller clips based on timestamps.
filename=$1
cut_list=$2
out_path=$3
# out_path must not have a trailing slash

# does the output directory exist?
  if [ ! -d "$out_path" ]; then
    while true; do
      read -p "Do you wish to create directory $out_path?" yn
      case $yn in
          [Yy]* ) mkdir $out_path; break;;
          [Nn]* ) echo "Ok."; exit;;
          * ) echo "Please answer yes or no.";;
      esac
    done
  fi
# read in a csv, use those values to create individual files via ffmpeg.
# Check to see if the video exists
if [[ -f "$filename" ]]
  then
# now check to see if the cut_list exists
    echo "Yes we have a video"
    if [[ -f "$cut_list" ]]
# The cut list exists, let's chop it up.
      then
        echo "yes we have a cut list."
        while IFS=, read start_time end_time clip_title
        do
          echo "Get to the Chopper!"
          ffmpeg -i $filename -ss $start_time -to $end_time -strict -2 ${out_path%/}/${clip_title// /_}.mp4 < /dev/null
        done < $cut_list
# if the cut list does not exist, exit.
      else echo "That cut list doesn't exist. Try again"
        exit
    fi
# if the cut video does not exist, exit.
  else echo "That video doesn't exist. Try again"
    exit
fi

# optional - upload cuts to Rackspace Cloud Files. Requires install of turbolift.
turbolift --internal -u $OS_USERNAME -a $OS_API_KEY --os-rax-auth $OS_RAX_AUTH upload -s $out_path -c oh-clips
