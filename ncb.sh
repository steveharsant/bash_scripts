#!/bin/bash

 #===================================================#
 #                New Chromium Browser               #
 #               Author: Steven Harsant              #
 #                  Date: xx/xx/20xx                 #
 #                   Version: 1.0                    #
 #===================================================#"
 #                                                   #
 #                      Notes                        #
 #   Made for the lazy sysadmin and those that don't #
 #             like using the trackpad               #
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
 #                 Builtin Functions                 #
 #                                                   #
 #===================================================#
function USAGE { #Prints usage information about the script
  echo "New Chromium Browser"
  echo "Launch a Chromium instance with a temporary profile"
  echo " "
  echo "  Usage:"
  echo "   ncb -ARGUMENT"
  echo " "
  echo "  Options:"
  echo "   -g     Open G Suite Administrator Portal"
  echo "   -o     open Office 365 Administrator Portal"
  echo "   -h     Display help"
  echo "   -v     Display version"

  exit 0
}

 #===================================================#
 #                                                   #
 #                       Swithes                     #
 #                                                   #
 #===================================================#

while getopts ":g :h :o :v" opt; do
  case $opt in
    g)
      printf "${INFO} Opening admin.google.com in Chromium\n"
      chromium-browser --temp-profile admin.google.com  </dev/null &>/dev/null &
      exit 0
      ;;
    h)
      USAGE
      ;;
    o)
      printf "${INFO} Opening login.microsoftonline.com in Chromium\n"
      chromium-browser --temp-profile login.microsoftonline.com  </dev/null &>/dev/null &
      exit 0
      ;;
    v)
      echo "version 1.0"
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
 #                       End                         #
 #                                                   #
 #===================================================#
