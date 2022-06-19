#!/bin/bash

version='2.0.0'

# Source helpers script
. "$(dirname "$0")/helpers.sh"

print_help(){
  printf 'WiFi Password Extractor\n\n'
  printf '  Usage:\n'
  printf '  wfp [SSID NAME/ARGUMENTS]\n\n'
  printf '  Options:\n'
  printf '   -l     List all known system connections\n'
  printf '   -r     Remove a known system connection\n'
}

remove_connection(){
  ssid=$1
  if rm -f "/etc/NetworkManager/system-connections/$ssid"; then
    log PASS "Removed connection $ssid"
    exit 0
  else
    log FAIL "Failed to remove connection $ssid. Was this script run with sudo?"
    exit 1
  fi
}

# -l Lists all known system connections
while getopts ":l:r:v" opt; do
  case $opt in
    l) ls -1 /etc/NetworkManager/system-connections; exit 0 ;;
    r) remove_connection "$OPTARG" ;;
    v) printf "$version\n"; exit 0 ;;
    *) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done

if [[ -z $1 ]]; then
  print_help
fi

ssid=$1

if [[ -f "/etc/NetworkManager/system-connections/$ssid" ]]; then
    psk=$(< "/etc/NetworkManager/system-connections/$ssid")
    psk=$(echo "$psk" | grep psk= | sed 's/^.\{4\}//g')
    printf "Password for ${YELLOW}$ssid${WHITE} is ${GREEN}$psk${WHITE} \n"
  else
    printf "${FAIL} No known system connection for ${YELLOW}$ssid${WHITE} \n"
fi

exit 0
