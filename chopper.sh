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
    # A)  #set option "a"
    #   audio=$OPTARG
    #   # echo "-A used, we'll export an mp3 for you."
    #   # echo "OPT_A = $audio"
    #   ;;
    f)  #set option "f"
      filename=$OPTARG
      # echo "-f used: $OPTARG"
      # echo "input file name = $filename"
      ;;
    c)  #set option "c"
      cut_list=$OPTARG
      # echo "-c used: $OPTARG"
      # echo "Cut list = $cut_list"
      ;;
    E)  #set option "E"
      container=$OPTARG
      # echo "-E used: $OPTARG"
      # echo "We will export to Cloud Files container = $container"
      ;;
    o)  #set option "o"
      out_path=$OPTARG
      # echo "-o used: $OPTARG"
      # echo "Output path = $out_path"
      ;;
    h)  #show help
      usage
      ;;
    \?) #unrecognized option - show help
      echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
      usage
      ;;
  esac
done

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.

# ----- End getopts -----

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
  while IFS=, read start_time end_time clip_title
  do
    echo "Chopping $clip_title"
    echo "nohup ffmpeg -i $filename -ss $start_time -to $end_time -strict -2 ${out_path%/}/${clip_title// /_}.mp4 < /dev/null &"
    echo "$clip_title Finished"
  done < $cut_list
# if the cut list does not exist, exit.
      else echo "That cut list doesn't exist. Try again"
        exit
    fi
# if the cut video does not exist, exit.
  else echo "That video doesn't exist. Try again"
    exit
fi

if [ ! -z "$container" ]
  then
    echo "Let's upload these files. Shipping them off to your container named $container."
    echo "turbolift --os-endpoint-type internalURL -u $OS_USERNAME -a $OS_API_KEY --os-rax-auth $OS_RAX_AUTH upload -s $clip_path -c" $container
fi
