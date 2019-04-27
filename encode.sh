#!/bin/bash

#TODO verify file type, check for mkv

while getopts i:o:m:l: option; do
  case $option in
    i) input_dir=$OPTARG;;
    o) output_dir=$OPTARG;;
    m) move_source_dir=$OPTARG;;
    l) log_dir=$OPTARG;;
  esac
done

encoder=${ENCODER:-libx265}
crf=${CRF:-28}
preset=${PRESET:-medium}

tune_param=""
test ! -z $TUNE && tune_param="-tune ${TUNE}"

eval processes=( $(ps aux | grep -i "ffmpeg -i" | awk '{print $11}') )
files=$(ls "$input_dir")
file=$(ls  "$input_dir" | sort -n | head -1)
short_file="${file%.*}"
should_start_new_encode=true


file_check() {
  if [ "$files" != "" ] ;then
    echo "Found file, encoding $file"
    # start_encode_docker
    start_encode
    move_original
  else 
    echo "No File Found"
  fi
}

start_encode(){
  ffmpeg -i "$input_dir"/"$file" \
  "$output_dir"/"$short_file".mkv \
  -map 0 -c copy\
  -c:v "$encoder" \
  -crf "$crf" \
  -preset "$preset" \
  $tune_param \
  > /dev/stdout
  # >> "$log_dir"/ffmpeg.log 2>&1
}

process_check(){
  for i in $processes; do
    if [ $i == "ffmpeg" ] ;then
      should_start_new_encode=false
      echo "ffmpeg is already running"
    fi 
  done
}

move_original(){
  mv "$input_dir"/"$file" "$move_source_dir"/"$file"
}

echo `date +"%Y-%m-%d-%T"`
process_check
if [ $should_start_new_encode == "true" ] ; then
  file_check
fi
echo
