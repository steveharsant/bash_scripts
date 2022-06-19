#!/bin/bash

#
# Start RDP connection from the terminal using preconfigured remmina configurations
#

version='2.0.0'

# Source helpers script
. "$(dirname "$0")/helpers.sh"

# Prints help message
print_help() {
  printf "RDP v$version\n\n"
  printf '  Usage:\n'
  printf '    rdp {PROFILENAME|ARGUMENT}\n\n'
  printf '  Options:\n'
  printf '   -h             Display help\n'
  printf '   -k             Kill all active RDP sessions\n'
  printf '   -l [string]    List known RDP connections\n'
  printf '   -n             Create a new connection profile\n'
  printf '   -v             Display version\n'

  exit 0
}

list_remmina_profiles() {
  if [[ -n "$1" ]]; then
    filter="=$1"
  fi

  # Get list of remmina profiles matching given filter
  grep -rnwi "$HOME/.remmina" -e name$filter |  cut -d= -f2
  exit 0
}

while getopts 'hkl:nv' opt; do
  case $opt in
    h) print_help ;;
    k) pkill -f remmina; exit 0 ;;
    l) list_remmina_profiles "$OPTARG" ;;
    n) remmina -n; exit 0 ;;
    v) printf "$version\n" ;;
    *) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done

#Check a remote server is specified.
if [[ -z "$1" ]]; then
 log FAIL 'No server specified for connection'
 exit 1
fi

case $(grep -rnwi "$HOME/.remmina" -e name="$1" | wc -l) in
  0) log FAIL "No connection profile found for server: $1"; exit 1 ;;
  [2-9]*) log FAIL "Multiple connection profiles found for server: $1"; exit 1 ;;
esac

#Initiate connection with Remmina
printf "${INFO} Connecting to ${YELLOW}${CONNECTIONSTRING}${WHITE}\n"
remmina -c "$(grep -rnwil "$HOME"/.remmina -e name="$1")"  </dev/null &>/dev/null &

exit 0
