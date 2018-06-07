#!/bin/bash

#===================================================#
#                  Random Background                #
#               Author: Steven Harsant              #
#                  Date: 07/06/2018                 #
#                   Version: 1.0                    #
#===================================================#"
#                                                   #
#      Randomises a background from a dirctory      #
#                                                   #
#===================================================#
#                                                   #
#       I accept no liability. No warranty.         #
#               Use at your own risk.               #
#                                                   #
#===================================================#

#===================================================#
#                                                   #
#                  Script Variables                 #
#                                                   #
#===================================================#

#Human Readable Aguement Variables#
#---------------------------------#
VAR1=$1
VAR2=$2
VAR3=$3

#Output Colour Variables#
#-----------------------#
WHITE='\033[1;37m'
RED='\033[0;91m'
GREEN='\33[92m'
YELLOW='\033[93m'
BLUE='\033[1;34m'

#Verbose Output Formatting#
#-------------------------#
FAIL=${RED}'FAIL:'${WHITE} #FAIL MESSAGES
PASS=${GREEN}'PASS:'${WHITE} #PASS MESSAGES
INFO=${YELLOW}'INFO:'${WHITE} #INFO MESSAGES
HINT=${BLUE}'HINT:'${WHITE} #HINT MESSAGES

#Environment Variables#
#---------------------#
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )" #Script path
USERNAME=`awk -F'[/:]' '{if ($3 >= 1000 && $3 != 65534) print $1}' /etc/passwd | head -n 1` #Logged in username
HOMEPATH="/home/${USERNAME}" #Logged in user homepath

BACKGROUNDPATH=(${HOMEPATH}/Pictures/wallpapers) #Path to backgrounds directory. Only change this variable

BACKGROUNDS=($BACKGROUNDPATH/*)
BACKGROUNDCOUNT=`ls ${BACKGROUNDPATH} -l | grep -v ^l | wc -l`; BACKGROUNDCOUNT="$((BACKGROUNDCOUNT - 2))"
RANDNUM=`shuf -i 0-${BACKGROUNDCOUNT} -n 1`

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

while getopts ":h:v" opt; do
  case $opt in
    h)
    #===================================================#
    #                                                   #
    #                 Usage Explanation                 #
    #                                                   #
    #===================================================#

      echo "Random Backgound Image"
      echo "  Usage:"
      echo "  rbk [ARGUMENT]"
      echo " "
      echo "  Options:"
      echo "   -h     Display help"

      exit 0
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


#===================================================#
#                                                   #
#                      Start                        #
#                                                   #
#===================================================#



gsettings set org.gnome.desktop.background picture-uri "file://${BACKGROUNDS[${RANDNUM}]}"
