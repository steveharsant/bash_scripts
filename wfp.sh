#!/bin/bash

#===================================================#
#                 WFP: WiFi Password                #
#               Author: Steven Harsant              #
#                  Date: 5/6/2018                   #
#                   Version: 1.0                    #
#===================================================#

#Set Colour Variables For Output#
#-------------------------------#
WHITE='\033[1;37m'
RED='\033[0;91m'
GREEN='\33[92m'
YELLOW='\033[93m'
BLUE='\033[1;34m'

FAIL=${RED}'FAIL:'${WHITE} #FAIL MESSAGES
PASS=${GREEN}'PASS:'${WHITE} #PASS MESSAGES
INFO=${YELLOW}'INFO:'${WHITE} #INFO MESSAGES
HINT=${BLUE}'HINT:'${WHITE} #HINT MESSAGES

if [[ -f /etc/NetworkManager/system-connections/$1 ]]
  then
    PSK=`sudo cat /etc/NetworkManager/system-connections/$1 | grep psk= | sed 's/^.\{4\}//g'`
    printf "Password for ${YELLOW}$1${WHITE} is ${GREEN}$PSK${WHITE} \n"
  else
    printf "${FAIL} No password for $1 found \n"
fi
