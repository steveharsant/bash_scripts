#!/bin/bash

#===================================================#
#                 WFP: WiFi Password                #
#               Author: Steven Harsant              #
#                  Date: 5/6/2018                   #
#                   Version: 1.2                    #
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

#Human Readable Variables#
#------------------------#
SSID=$1

#Script Arguements#
#-----------------#

# -l Lists all known system connections
while getopts ":l:" opt; do
  case $opt in
    l)
      echo "-l does not accept parameters" >&2
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      ls /etc/NetworkManager/system-connections >&2
      exit 0
      ;;
  esac
done


#If No Arguements Are Passed Output Info#
#---------------------------------------#
if [[ -z $SSID ]]; then
  echo "WiFi Password Extractor"
  echo "  Usage:"
  echo "  wfp [SSID NAME]"
  echo " "
  echo "  Options:"
  echo "   -l     List all known system connections"

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
if [[ -f /etc/NetworkManager/system-connections/$SSID ]]
  then
    PSK=`sudo cat /etc/NetworkManager/system-connections/$SSID | grep psk= | sed 's/^.\{4\}//g'`
    printf "Password for ${YELLOW}$SSID${WHITE} is ${GREEN}$PSK${WHITE} \n"
  else
    printf "${FAIL} No known system connection for ${YELLOW}$SSID${WHITE} \n"
fi
