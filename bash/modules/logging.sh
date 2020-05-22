#!/usr/bin/env bash
#
# Pluggable logging Module
# version: 0.0.1
# Author: Steve Harsant

# Set liniting rules
# shellcheck disable=SC2059
# shellcheck disable=SC2091
# shellcheck disable=SC2164

# write-log --level dubug --timeformat {{UTC / 'HH:mm:ss:nnnnnn dd/MM/YYYY'}} --message 'foo bar' --additionalfields 'a=1,b=2' --file '/path/to/log'
# OR #
# write-log dubug {{UTC / 'HH:mm:ss:nnnnnn dd/MM/YYYY'}} 'foo bar' 'a=1,b=2' '/path/to/log' ???

### Callable methods ###
delete_log() {
  echo $1
}

read_log() {
  echo $1
}

rotate_log() {
  echo $1
}

write_log() {
  echo $1
}

### Sub Routines ###
derive_timestamp() {
  echo $1
}

format_log() {
  echo $1
}

parse_additional_fields() {
  echo $1
}

parse_level() {
  echo $1
}

print_help() {
  echo 1
}

## Start Script ##

# Test if arguments were passed and derive argument format
if [ -z "$*" ]; then
  print_help
  exit 0
fi

# Derive agument values
for arguement in "$@"; do
  case "$arguement" in
  '-l' | '--level') level="${*: +1}" ;;
  '-m' | '--message') message="${*: +1}" ;;
  '-t' | '--timeformat') time_format="${*: +1}" ;;
  '-a' | '--additionalfields') additional_fields="${*: +1}" ;;
  '-s' | '--syntax') syntax="${*: +1}" ;;
  '-f' | '--file') file_path="${*: +1}" ;;
  '-h' | '--help') print_help ;;
  *)
    for flagless_arguement in "$@"; do
      case "$flagless_arguement" in
      'Fatal' | 'Error' | 'Warn' | 'Info' | 'Debug' | 'Trace')
        level=$flagless_arguement
        ;;
      '*=*') additional_fields=$flagless_arguement ;;
      esac
    done

    level=$1
    message=$2
    time_format=$3
    additional_fields=$4
    syntax=$5
    file_path=$
    ;;
  esac
done
