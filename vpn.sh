#!/bin/bash

version='2.0.0'
start_time=$(date +%s)

# Source helpers script
. "$(dirname "$0")/helpers.sh"

function print_help {
  echo "Script long name"
  echo "  Usage:"
  echo "  (SCRIPTNAME) [ARGUMENT1] [ARGUEMENT2] [ARGUEMENT3]"
  echo " "
  echo "  Options:"
  echo "   -a     Switch Explanation"
  echo "   -b     Switch Explanation"
  echo "   -c     Switch Explanation"
  echo "   -h     Display help"
  echo "   -v     Display version"

  exit 0
}

restart_network_manager() {
  if service network-manager restart; then
    log PASS 'Network Manager restarted'
    exit 0

  else
    log FAIL 'Network Manager failed to restart. Was this script run with sudo?'
    exit 1
  fi
}

disconnect_vpn_connection() {
  connection=$1

  # Disconnect the specified VPN connection
  if [[ $(nmcli | grep "vpn connection" | awk '{print $1;}') ]]; then
    log INFO "Disconnecting from $connection"
    result=$(nmcli c down "$connection")

    if [[ $result == *'successfully deactivated'* ]]; then
      log PASS "Successfully disconnected from $connection"

      # Restarting the network manager is a bit of a dirty work around
      # as ocasionally the routing table is not updated properly. I don't
      # love this fix, but life is too short.
      restart_network_manager

    else
      log FAIL 'Failed to disconnect. Restarting NetworkManager'
      restart_network_manager
      exit 1
    fi

  else
    log WARN 'There are no vpn tunnels to disconnect'
    exit 0
  fi
  exit 0
}

list_connections(){
  printf 'Available vpn tunnels:\n'
  nmcli con | grep vpn | awk '{print $1;}'
  exit 0
}

show_vpn_status(){
  log INFO 'Connected vpn tunnels:'
  nmcli | grep "vpn connection" | awk '{print $1;}'
  exit 0
}

print_execution_time() {
  start_time=$1
  end_time=$(date +%s)

  execution_time=$((end_time - start_time))

  if [ $execution_time -le 60 ]; then
		 log INFO "Script ran for $execution_time seconds"
	else
		execution_time=$((execution_time / 60))
		log INFO "Script ran for $execution_time minutes \n"
  fi
}

while getopts "d:lshv" opt; do
  case $opt in
    d) disconnect_vpn_connection "$OPTARG" ;;
    l)list_connections ;;
    s) show_vpn_status ;;
    h) print_help ;;
    v) printf "$version\n" && exit 0 ;;
    *) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done

if [[ -z $1 ]]; then
  print_help
fi

vpn=$1

if [[ $(nmcli | grep "vpn connection" | awk '{print $vpn;}') ]]; then
  #If vpn is connected
  log "$vpn is already connected"
  printf "${BLUE}To disconnect from $vpn use the ${YELLOW}-d${WHITE} switch\n"

else
  #If vpn is not connected
  log INFO "Connecting to $vpn"
  result=$(nmcli c up "$vpn")

  if [[ $result == *'Connection successfully activated'* ]]; then
    log PASS "Successfully connected to $vpn"
  fi
fi

print_execution_time "$start_time"
