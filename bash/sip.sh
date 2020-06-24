#!/bin/bash

# Simple IP Address List (sip)
# A simple way to output ip address information

# Get IP address and loop through output
ip a s  | while read -r LINE ; do
  # If the line starts with a digit [0-9], get contents between : characters
  if [[ $LINE =~ ^[0-9] ]];then
    INT=$(grep -oP '(?<=:).*?(?=:)' <<< "$LINE" | tr -d ' ')
  fi
  # If the line contains 'inet', get matching contents
  if [[ $LINE =~ 'inet' ]]; then
    IP=$(grep -oP '(\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b\/\d{1,2})' <<< "$LINE")
    # If an IP address is stored as a variable, echo the interface and IP address
    if [[ -n $IP ]]; then
      echo "$INT: $IP"
    fi
  fi
done
