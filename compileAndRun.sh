#!/bin/bash

file_dir_flag=false
output_file_dir_flag=false
get_child_arg_flag=false
output_file_name="a.out"
wait_user=false

file_dir=""
output_file_dir=$PWD/a.out
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

  if [[ $arg == "-i" ]] || [[ $arg == "--input-file" ]]; then
    file_dir_flag=true
  fi

  # GET OUTPUT FILE:
  if [[ $output_file_dir_flag == true ]]; then
    output_file_dir=$arg
    if [[ $arg != /* ]]; then
      output_file_dir=$PWD/$arg
      output_file_name=$arg
    else
      output_file_name=$(basename $arg)
    fi
    output_file_dir_flag=false
  fi

  if [[ $arg == "-o" ]] || [[ $arg == "--output-file" ]]; then
    output_file_dir_flag=true
  fi

  # GET CHILD ARGUMENTS
  if [[ $get_child_arg_flag == true ]]; then
    child_arg=$arg
    get_child_arg_flag=false
  fi

  if [[ $arg == "-a" ]] || [[ $arg == --arguments ]]; then
    get_child_arg_flag=true
  fi

  if [[ $arg == "-w" ]] || [[ $arg == "--wait-user" ]]; then
    wait_user=true
  fi
done

if [[ -f "$file_dir" ]]; then
  g++ $file_dir -o $output_file_dir
  xreturnval=$?
  if [[ $xreturnval == 0 ]]; then 
    $PWD/./$output_file_name $child_arg
  fi
else 
  echo "[-] no such file or directory: $file_dir"
fi

if [[ $wait_user == true ]]; then
  echo "%"
  read -p "[Press enter to continue]"
fi
