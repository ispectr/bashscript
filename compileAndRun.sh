#!/bin/bash

input_file="main.c"
output_file="a.out"
outfile_basename="a.out"
arguments=""
wait_user=false
positional_args=()
wait_user=false

while [[ $# -gt 0 ]]; do
  case $1 in
    -i|--input-file)
      input_file="$2"
      if [[ $2 != /* ]]; then
        input_file=$PWD/$2
      fi
      infile_basename=$(basename $2)
      shift
      shift
      ;;

    -o|--output-file)
      output_file="$2"
      if [[ $2 != /* ]]; then
        output_file=$PWD/$2
      fi
      outfile_basename=$(basename $2)
      shift
      shift
      ;;

    -a|--arguments)
      arguments="$2"
      shift
      shift
      ;;

    -w|--wait-user)
      wait_user=true
      shift
      ;;

    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;

    *)
      positional_args+=($1)
      shift
      ;;
  esac
done

echo "input file = $input_file"
echo "ouput file = $output_file"
echo "arguments  = $arguments"

if [[ -f "$input_file" ]]; then
  g++ $input_file -o $output_file
  if [[ $? == 0 ]]; then
    $PWD/./$outfile_basename $arguments
  fi
else
  echo "[-] no such file or directry: $input_file"
fi

if [[ $wait_user == true ]]; then
  echo "%"
  read -p "[Press enter to continue]"
fi
