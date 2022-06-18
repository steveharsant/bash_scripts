#!/usr/bin/env bash

#
# Functions for use in other scripts
#

# Set ansi colours
BLUE='\033[1;34m\033[48;5;0m'
GREEN='\033[92m\033[48;5;0m'
ORANGE='\033[38;5;208m\033[48;5;0m'
RED='\033[0;91m\033[48;5;0m'
WHITE='\033[1;37m\033[48;5;0m'
YELLOW='\033[93m\033[48;5;0m'

# Logs a colourised, formatted message to stdout/err
log() {

  # Exit function if debug message and debugging is not enabled
  if [[ $1 == "debug" && ${DEBUG^^} != "TRUE" ]]; then
    return 0
  fi

  # If first argument is not any level status, assume it's part of the message
  if [[ ${1^^} =~ ^INFO|DEBUG|PASS|WARN|FAIL|CRIT$ ]]; then
    level=${1^^}
    message=${*:2}
  else
    level=INFO
    message=$*
  fi

  # if level is crit or fail, set colour to red
  if [[ "$level" =~ ^CRIT|FAIL$ ]]; then
    stream='2'
  else
    stream='1'
  fi

  # Colourise log levels
  case "$level" in
    "INFO") level="${BLUE}[ $level ]${WHITE}";;
    "DEBUG") level="${YELLOW}[ $level ]${WHITE}";;
    "PASS") level="${GREEN}[ $level ]${WHITE}";;
    "WARN") level="${ORANGE}[ $level ]${WHITE}";;
    "FAIL") level="${RED}[ $level ]${WHITE}";;
    "CRIT") level="${RED}[ $level ]${RED}";;
  esac

  # Write log out to stdout/err, depending on log level
  >&$stream printf "$level $message${WHITE}\n"
}
