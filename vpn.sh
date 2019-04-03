#!/bin/bash

 #===================================================#
 #                      VPN Connect                  #
 #               Author: Steven Harsant              #
 #                  Date: 08/10/2018                 #
 #                   Version: 1.0                    #
 #===================================================#"
 #                                                   #
 #                      Notes                        #
 #                                                   #
 #===================================================#
 #                                                   #
 #       I accept no liability. No warranty.         #
 #               Use at your own risk.               #
 #                                                   #
 #===================================================#

 #===================================================#
 #                                                   #
 #                     User Options                  #
 #                                                   #
 #===================================================#

 #===================================================#
 #                                                   #
 #                  Script Variables                 #
 #                                                   #
 #===================================================#

#Start Script Timer#
#------------------#
START=$(date +%s)

#Human Readable Aguement Variables#
#---------------------------------#
VPN=$1
KILLVPN=$2
VAR3=$3

#Output Colour Variables#
#-----------------------#
BLUE='\033[1;34m'
GREEN='\33[92m'
ORANGE='\033[38;5;208m'
RED='\033[0;91m'
WHITE='\033[1;37m'
YELLOW='\033[93m'

#Verbose Output Formatting#
#-------------------------#
PASS=${GREEN}'PASS:'${WHITE} #PASS MESSAGES
FAIL=${RED}'FAIL:'${WHITE} #FAIL MESSAGES
INFO=${YELLOW}'INFO:'${WHITE} #INFO MESSAGES
WARN=${ORANGE}'WARN:'${WHITE} #INFO MESSAGES
HINT=${BLUE}'HINT:'${WHITE} #HINT MESSAGES

#Environment Variables#
#---------------------#
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )" #Script path
USERNAME=`awk -F'[/:]' '{if ($3 >= 1000 && $3 != 65534) print $1}' /etc/passwd | head -n 1` #Logged in username
HOMEPATH="/home/${USERNAME}" #Logged in user homepath

 #===================================================#
 #                                                   #
 #                     Functions                     #
 #                                                   #
 #===================================================#

 #===================================================#
 #                                                   #
 #                 Builtin Functions                 #
 #                                                   #
 #===================================================#
function USAGE { #Prints usage information about the script
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

  exit
}

function RUNTIME { #Call to output runtime of script
  END=$(date +%s)
  DIFF=$(( ${END} - ${START} ))

  if [ ${DIFF} -le 60 ]; then
		 printf "${INFO} Script run time was ${DIFF} seconds \n"
	else
		DIFF=$(( ${DIFF} / 60 ))
		printf "${INFO} Script run time was ${DIFF} minutes \n"
  fi
}

 #===================================================#
 #                                                   #
 #                       Swithes                     #
 #                                                   #
 #===================================================#

while getopts ":d:l:s" opt; do
  case $opt in
    d) # Disconnect VPN

      if [[ $(nmcli | grep "VPN connection" | awk '{print $1;}') ]]; then
        printf "${INFO} Disconnecting from ${KILLVPN} \n"
        RESULT=$(nmcli c down ${KILLVPN})

        if [[ $RESULT == *"successfully deactivated"* ]]; then
          printf "${PASS} Successfully disconnected from ${KILLVPN} \n"
          sudo service network-manager restart
          exit 0
        else
          printf "${FAIL} failed to disconnect. Restarting NetworkManager"
          sudo service network-manager restart
          exit 1
        fi


      else
        printf "${WARN} There are no VPN tunnels to disconnect \n"
        exit 0
      fi
      exit 0
      ;;

    l) #List all VPN connections
      printf "${INFO} Available VPN tunnels: \n"
      nmcli con | grep vpn | awk '{print $1;}'
      exit 0
      ;;

    s) #Get status of connected VPN tunnels.
      printf "${INFO} Connected VPN tunnels: \n"
      nmcli | grep "VPN connection" | awk '{print $1;}'
      exit 0
      ;;

    h)
      USAGE
      ;;

    v)
      echo "version 1.0"
      ;;

    :)
      #STATEMENTS >&2
      ;;

  \?)
    echo "Invalid option: -$OPTARG" >&2
    exit 1
    ;;
  esac
done

#If No Arguements Are Passed Output Info#
#---------------------------------------#
if [[ -z $1 ]]; then
  echo "VPN Connect (Based on nmcli)"
  echo "Author: Steven Harsant"
  echo ""
  echo "  Usage:"
  echo "  vpn [VPN TUNNEL]"
  echo " "
  echo "  Options:"
  echo "   -d     Disconnect from vpn tunnel"
  echo "   -l     List all known vpn tunnels"
  echo "   -s     Get status of vpn tunnels"
  echo "   -v     Print version"

  if [[ ! -f /usr/bin/wfp ]]; then
    printf "First run prompts to be installed to /usr/bin/ \n"
  fi

  exit
fi

 #===================================================#
 #                                                   #
 #                      Start                        #
 #                                                   #
 #===================================================#
 if [[ $1 == "-l" ]]; then #As hacky as hacky gets... 
   printf "${INFO} Available VPN tunnels: \n"
   nmcli con | grep vpn | awk '{print $1;}'
   exit 0

 else

if [[ $(nmcli | grep "VPN connection" | awk '{print $1;}') ]]; then
  #If VPN is connected
printf "${INFO} ${VPN} is already connected \n"
printf "${HINT} To disconnect from ${VPN} use the ${YELLOW}-d${WHITE} switch \n"
else
  #If VPN is not connected
  printf "${INFO} Connecting to ${VPN} \n"
  RESULT=$(nmcli c up ${VPN})

  if [[ $RESULT == *"Connection successfully activated"* ]]; then
    printf "${PASS} Successfully connected to ${VPN} \n"
  fi
fi

fi


 #===================================================#
 #                                                   #
 #                       End                         #
 #                                                   #
 #===================================================#

#UNCOMMENT TO ECHO RUNTIME OF SCRIPT
#RUNTIME
