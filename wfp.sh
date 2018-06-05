#!/bin/bash

#===================================================#
#                 WFP: WiFi Password                #
#               Author: Steven Harsant              #
#                  Date: 5/6/2018                   #
#                   Version: 1.1                    #
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

#Get Script Path#
#---------------#
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
SCRIPTNAME=`basename "$0"`

#If No Arguements Are Passed Output Info#
#---------------------------------------#
if [[ -z $1 ]]; then
  printf "WiFi Password Extractor \n"
  printf "Usage: wfp [SSID NAME] \n"

  if [[ ! -f /usr/bin/wfp ]]; then
    printf "First run prompts to be installed to /usr/bin/ \n"
  fi

  exit
fi

#Check If Installed and Install Itself#
#-------------------------------------#
if [[ ! -f /usr/bin/wfp ]]; then
  printf "${INFO} wfp not installed. Would you like to install this script? \n"

  while true; do
      read -p "Continue [y/n]?" YN
      case $YN in
          [Yy]* ) sudo cp ${SCRIPTPATH}/${SCRIPTNAME} /usr/bin/wfp
                  sudo chmod +x /usr/bin/wfp
                  break;;
          [Nn]* ) break;;
          * ) echo "Please answer yes or no";;
      esac
  done

fi

#Check For Config and Display Password#
#-------------------------------------#
if [[ -f /etc/NetworkManager/system-connections/$1 ]]
  then
    PSK=`sudo cat /etc/NetworkManager/system-connections/$1 | grep psk= | sed 's/^.\{4\}//g'`
    printf "Password for ${YELLOW}$1${WHITE} is ${GREEN}$PSK${WHITE} \n"
  else
    printf "${FAIL} No password for $1 found \n"
fi
