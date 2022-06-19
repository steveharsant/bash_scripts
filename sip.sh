#!/bin/bash

# Simple ip Address List (sip)
# A simple way to output ip address information

# Get ip address and loop through output
ip a s  | while read -r line ; do

  # If the line starts with a digit [0-9], get contents between : characters
  if [[ $line =~ ^[0-9] ]];then
    interface=$(grep -oP '(?<=:).*?(?=:)' <<< "$line" | tr -d ' ')
  fi

  # If the line contains 'inet', get matching contents
  if [[ $line =~ 'inet' ]]; then
    ip=$(grep -oP '(\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b\/\d{1,2})' <<< "$line")

    # If an ip address is stored as a variable, echo the interface and ip address
    if [[ -n $ip ]]; then
      printf "$interface: $ip\n"
    fi
  fi
done
