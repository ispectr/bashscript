#!/bin/bash

file_dir_flag=false
output_file_dir_flag=false
get_child_arg_flag=false

file_dir=""
output_file_dir=""
child_arg=""

# PARSE ARGUMENTS
for arg in "$@"; do
  
  # GET INPUT FILE:
  if [[ $file_dir_flag == true ]]; then
    file_dir=$arg
    if [[ $arg != /* ]]; then
      file_dir=$PWD/$arg
    fi
    file_dir_flag=false
  fi

  if [[ $arg == "--if" ]]; then
    file_dir_flag=true
  fi

  # GET OUTPUT FILE:
  if [[ $output_file_dir_flag == true ]]; then
    output_file_dir=$arg
    if [[ $arg != /* ]]; then
      output_file_dir=$PWD/$arg
    fi
    output_file_dir_flag=false
  fi

  if [[ $arg == "--of" ]]; then
    output_file_dir_flag=true
  fi

  # GET CHILD ARGUMENTS
  if [[ $get_child_arg_flag == true ]]; then
    child_arg=$arg
    get_child_arg_flag=false
  fi

  if [[ $arg == "--arg" ]]; then
    get_child_arg_flag=true
  fi
done

if [[ -f "$file_dir" ]]; then
  g++ $file_dir -o $output_file_dir
  xreturnval=$?
  $output_file_dir $child_arg
else 
  echo "[-] no such file or directory: $file_dir"
fi
