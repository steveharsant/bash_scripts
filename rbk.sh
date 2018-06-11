#!/bin/bash

#===================================================#
#                  Random Background                #
#               Author: Steven Harsant              #
#                  Date: 07/06/2018                 #
#                   Version: 1.1                    #
#===================================================#
#                                                   #
#      Randomises a background from a dirctory      #
#       OR downloads and sets Bings image of        #
#            the day as as the background           #
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

#Environment Variables#
#---------------------#
USERNAME=`awk -F'[/:]' '{if ($3 >= 1000 && $3 != 65534) print $1}' /etc/passwd | head -n 1` #Logged in username
HOMEPATH="/home/${USERNAME}" #Logged in user homepath

#User Options#
#------------#
BACKGROUNDPATH=(${HOMEPATH}/Pictures/wallpapers)      #Path to backgrounds directory.
SCREENDIMENSIONS="1920x1080"                          #Set screen dimensions for the attached monitor.

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

#===================================================#
#                                                   #
#                     Functions                     #
#                                                   #
#===================================================#

function GETBINGIMAGE { #Downloads Bing's image of the day.

  wget "https://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=en-US" --output-document=/tmp/bingimage.xml > /dev/null 2>&1

  URLBASE=$(xmllint --xpath "string(//images/image/urlBase)" /tmp/bingimage.xml)
  NAME=$(xmllint --xpath "string(//images/image/startdate)" /tmp/bingimage.xml)

  if [[ -f ${BACKGROUNDPATH}/${NAME}.jpg ]]; then
    printf "${INFO} Todays Bing image of the day already exists. Setting image from local cache \n"
  else
    wget "https://bing.com${URLBASE}_${SCREENDIMENSIONS}.jpg" --output-document=${BACKGROUNDPATH}/${NAME}.jpg > /dev/null 2>&1
  fi

  gsettings set org.gnome.desktop.background picture-uri "file://${BACKGROUNDPATH}/${NAME}.jpg"

  exit 0
}

#===================================================#
#                                                   #
#                 Usage Explanation                 #
#                                                   #
#===================================================#
function USAGE {

    echo "Random Backgound Image"
    echo "  Usage:"
    echo "  rbk [ARGUMENT]"
    echo " "
    echo "  Options:"
    echo "   -b     Download Bing's image of the day and apply as background."
    echo "          Backgrounds are currently downloaded to:"
    echo "          ${BACKGROUNDPATH}"
    echo "   -h     Display help"
    echo "   -v     Display version"

    exit 0
}

#===================================================#
#                                                   #
#                       Swithes                     #
#                                                   #
#===================================================#

while getopts ":vhb" opt; do
  case $opt in
    b)
      GETBINGIMAGE
      ;;

    h)
      USAGE
      ;;

    v)
      echo "version 1.1"
      exit 0
      ;;

    :)
      ;;

  \?)
    echo "Invalid option: -$OPTARG" >&2
    exit 1
    ;;
  esac
done

BACKGROUNDS=($BACKGROUNDPATH/*)
BACKGROUNDCOUNT=`ls ${BACKGROUNDPATH} -l | grep -v ^l | wc -l`; BACKGROUNDCOUNT="$((BACKGROUNDCOUNT - 2))"
RANDNUM=`shuf -i 0-${BACKGROUNDCOUNT} -n 1`

gsettings set org.gnome.desktop.background picture-uri "file://${BACKGROUNDS[${RANDNUM}]}"
