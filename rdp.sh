#!/bin/bash

 #===================================================#
 #                      Remmina RDP                  #
 #               Author: Steven Harsant              #
 #                  Date: 02/01/2019                 #
 #                   Version: 0.1                    #
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
 #                     User Options                  #
 #                                                   #
 #===================================================#

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
 #                     Functions                     #
 #                                                   #
 #===================================================#

 #===================================================#
 #                                                   #
 #                       Swithes                     #
 #                                                   #
 #===================================================#

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
  exit 1
fi

#Get full path to file with connection information
ENTRY=`grep -rnwil ${HOMEPATH}/.remmina -e name=${CONNECTIONSTRING}`

#Initiate connection with Remmina
printf "${INFO} Connecting to ${YELLOW}${CONNECTIONSTRING}${WHITE}...\n"
remmina -c ${ENTRY}  </dev/null &>/dev/null &

exit 0

 #===================================================#
 #                                                   #
 #                       End                         #
 #                                                   #
 #===================================================#
