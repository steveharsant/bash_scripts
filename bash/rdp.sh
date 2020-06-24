#!/bin/bash

 #===================================================#
 #                      Remmina RDP                  #
 #               Author: Steven Harsant              #
 #                  Date: 02/01/2019                 #
 #                   Version: 0.2                    #
 #===================================================#"
 #                                                   #
 #                      Notes                        #
 #  This is a quick script to make life easier with  #
 #   Remmina. I plan to make this more robust, add   #
 #   better error checking and more features later.  #
 #                                                   #
 #===================================================#
 #                                                   #
 #       I accept no liability. No warranty.         #
 #               Use at your own risk.               #
 #                                                   #
 #===================================================#

 #===================================================#
 #                                                   #
 #                     Functions                     #
 #                                                   #
 #===================================================#

function USAGE { #Prints usage information about the script
  echo "Remmina RDP (Version: 0.2)"
  echo "Connect to a remote Windows computer with Remmina"
  echo " "
  echo "  Usage:"
  echo "   rdp -ARGUMENT"
  echo " "
  echo "  Options:"
  echo "   -h             Display help"
  echo "   -k             Kill all active RDP sessions"
  echo "   -l [string]    List known RDP connections"
  echo "   -n             Create a new connection profile"
  echo "   -v             Display version"

  exit 0
}

 #===================================================#
 #                                                   #
 #                  Script Variables                 #
 #                                                   #
 #===================================================#

#Human Readable Aguement Variables#
#---------------------------------#
CONNECTIONSTRING=$1

#Script Variables#
#----------------#
USERNAME=`awk -F'[/:]' '{if ($3 >= 1000 && $3 != 65534) print $1}' /etc/passwd | head -n 1` #Logged in username
HOMEPATH="/home/${USERNAME}" #Logged in user homepath

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

#===================================================#
#                                                   #
#                       Swithes                     #
#                                                   #
#===================================================#

while getopts ":h :k :l :n :v" opt; do
 case $opt in
   h)
     USAGE
     ;;
   k)
     pkill -f remmina
     exit 0
     ;;
   l)
      if [[ -z "$2" ]]; then
        printf "${INFO} All known Remmina RDP connection profles: \n"
        grep -rnwi ${HOMEPATH}/.remmina -e name |  cut -d= -f2
      else
        printf "${INFO} Known Remmina RDP connection profiles for ${YELLOW}${2}${WHITE} \n"
        grep -rnwi ${HOMEPATH}/.remmina -e name=${2} |  cut -d= -f2
      fi

     exit 0
     ;;
   n)
     remmina -n
     exit 0
     ;;
   v)
     echo "Version 0.2"
     exit 0
     ;;
   :)
     exit 0
     ;;
 \?)
   echo "Invalid option: -$OPTARG" >&2
   exit 1
   ;;
 esac
done

 #===================================================#
 #                                                   #
 #                      Start                        #
 #                                                   #
 #===================================================#

#Check a remote server is specified.
if [[ -z ${CONNECTIONSTRING} ]]; then
 printf "${FAIL} No server specified for connection. \n"
 exit 1
fi

#Search for files with matching string and output integer value
ENTRYCOUNT=`grep -rnwi ${HOMEPATH}/.remmina -e name=${CONNECTIONSTRING} | wc -l`

#Check there is at least 1 matching entry found.
if [[ ${ENTRYCOUNT} -eq 0 ]]; then
  printf  "${FAIL} No matching Remmina RDP entries found. \n"
  exit 1
fi

#Check there is only 1 matching entry found
if [[ ${ENTRYCOUNT} -gt 1 ]]; then
  printf "${FAIL} Too many Remmina RDP entries found. Please be more specific.\n"
  printf "\n${HINT} RDP entries containing ${CONNECTIONSTRING}:\n"
  grep -rnwi ${HOMEPATH}/.remmina -e name=${CONNECTIONSTRING} |  cut -d= -f2

  exit 1
fi

#Get full path to file with connection information
ENTRY=`grep -rnwil ${HOMEPATH}/.remmina -e name=${CONNECTIONSTRING}`

#Initiate connection with Remmina
printf "${INFO} Connecting to ${YELLOW}${CONNECTIONSTRING}${WHITE}\n"
remmina -c ${ENTRY}  </dev/null &>/dev/null &

exit 0

 #===================================================#
 #                                                   #
 #                       End                         #
 #                                                   #
 #===================================================#
