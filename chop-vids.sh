#!/bin/bash

filename=$1
cut_list=$2
out_path=$3

while IFS=, read start_time end_time clip_title
do
  echo "Chopping $clip_title"
  nohup ffmpeg -i $filename -ss $start_time -to $end_time -strict -2 ${out_path%/}/${clip_title// /_}.mp4 < /dev/null &
  echo "$clip_title Finished"
done < $cut_list
