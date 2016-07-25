#!/bin/bash

# a little utility to cut an mp4 into smaller clips based on timestamps.

usage ()
{
  echo "The Chopper is a script to cut a single video file into shorter video files, "
  echo "based on a list of cut points. "
  echo "Complete documentation is available at https://github.com/albush/the-chopper"
  echo " "
  echo "Usage: "
  echo "  chopper [flags]"
  echo "  "
  echo "Required Flags:"
  echo "  -f file path. The path to your original video file."
  echo "  -c cut list. A comma separated list of points to cut."
  echo "  -o output path. The destination for finished clips."
  echo "  "
  echo "Optional Flags:"
  # echo "  -A Audio. Additionally export an mp3 version of the original video."
  echo "  -E Export to Cloud Files. Provide a Rackspace Cloud Files container. Requires the installation of turbolift."
  echo "  -h help. You're reading it now."
  exit
}

# ----- Begin getopts -----
while getopts :f:c:o:AE:h FLAG; do
  case $FLAG in
    A)  #set option "a"
      audio=1
      echo $audio
      ;;
    f)  #set option "f"
      filename=$OPTARG
      if [[ ! -f "$filename" ]]
      then
          echo "That video doesn't exist. Try again"
          exit
      else echo "Video......... Check!"
        fbname=$(basename "$filename" .mp4)
      fi
      ;;
    c)  #set option "c"
      cut_list=$OPTARG
      if [[ ! -f "$cut_list" ]]
        then
        echo "That cut list doesn't exist. Try again"
          exit
        else
          echo "Cut List........ Check!"
      fi
      ;;
    E)  #set option "E"
      container=$OPTARG
      ;;
    o)  #set option "o"
      out_path=$OPTARG
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
      ;;
    h)  #show help
      usage
      ;;
    \?) #unrecognized option - show help
      echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."; usage >&2; exit
      ;;
  esac
done
if [ $OPTIND -eq 1 ]; then echo "No options were passed"; usage; exit; fi
shift $((OPTIND-1))  #This tells getopts to move on to the next argument.

# ----- End getopts -----

# ----- Extract Audio -----
if [ $audio == 1 ]
  then
    echo "Extracting Audio from $filename"
    ffmpeg -i $filename  -strict -2 ${out_path%/}/${fbname// /_}.mp3
    # ffmpeg -i $filename  -strict -2 ${out_path%/}/${fbname// /_}.ogg 
    echo "$filename Audio Extraction Finished"
fi
# ----- End Audio Extraction -----

# read in a csv, use those values to create individual files via ffmpeg.
# chop the videos
while IFS=, read start_time end_time clip_title
do
  echo "Chopping $clip_title"
  nohup ffmpeg -i $filename -ss $start_time -to $end_time -strict -2 ${out_path%/}/${clip_title// /_}.mp4 < /dev/null &
  echo "$clip_title Finished"
done < $cut_list

# Optional Export

if [ ! -z "$container" ]
  then
    echo "Let's upload these files. Shipping them off to your container named $container."
    turbolift --os-endpoint-type internalURL -u $OS_USERNAME -a $OS_API_KEY --os-rax-auth $OS_RAX_AUTH upload -s $clip_path -c $container
fi
