#!/bin/bash

#===================================================#
#              Make Script From Template            #
#               Author: Steven Harsant              #
#                  Date: 06/06/2018                 #
#                   Version: 1.0                    #
#===================================================#
#                                                   #
#   Copies a script template from a directory and   #
#   places it in default directory and renames it   #
#                                                   #
#===================================================#
#                                                   #
#       I accept no liability. No warranty.         #
#               Use at your own risk.               #
#                                                   #
#===================================================#

#===================================================#
#                                                   #
#                 Usage Explanation                 #
#                                                   #
#===================================================#

if [[ -z $1 ]]; then
  echo "Make Script From Template"
  echo "  Usage:"
  echo "   mkscr [FILENAME]"
  echo " "
  echo "  Options:"
  echo "   -p     Set path other than default. Excluding a path will"
  echo "          create a new script the present working directory"
  echo "   -s     Print settings"
  echo "   -v     Print version"
  echo ""
  echo "  Examples:"
  echo "   mkscr NewScript.sh"
  echo "   mkscr -p NewScript.sh"
  echo "   mkscr -p ~/path/to/destination/NewScript.sh"
  exit 0
fi

#===================================================#
#                                                   #
#                  Script Variables                 #
#                                                   #
#===================================================#

#Human Readable Aguement Variables#
#---------------------------------#
SCRIPTNAME=$1
PATHWAY=$2
VAR3=$3

#Output Colour Variables#
#-----------------------#
WHITE='\033[1;37m'
RED='\033[0;91m'
GREEN='\33[92m'
YELLOW='\033[93m'
BLUE='\033[1;34m'
ORANGE='\033[38;5;208m'

#Verbose Output Formatting#
#-------------------------#
FAIL=${RED}'FAIL:'${WHITE} #FAIL MESSAGES
PASS=${GREEN}'PASS:'${WHITE} #PASS MESSAGES
INFO=${YELLOW}'INFO:'${WHITE} #INFO MESSAGES
WARN=${ORANGE}'WARN:'${WHITE} #INFO MESSAGES
HINT=${BLUE}'HINT:'${WHITE} #HINT MESSAGES

#Environment Variables#
#---------------------#
MYPATH="$( cd "$(dirname "$0")" ; pwd -P )" #Path of this script
USERNAME=`awk -F'[/:]' '{if ($3 >= 1000 && $3 != 65534) print $1}' /etc/passwd | head -n 1` #Logged in username
HOMEPATH="/home/${USERNAME}" #Logged in user homepath

SCRIPTPATH="${HOMEPATH}/scripts" #Top level scripts directory
BASHPATH="${SCRIPTPATH}/bash" #Bash scripts directory
PSHELLPATH="${SCRIPTPATH}/powershell" #Powershell scripts directory
BATPATH="${SCRIPTPATH}/cmd" #batch scripts directory

TEMPLATEPATH="${HOMEPATH}/scripts/templates" #Directory storing all templates
BASHTMP="${TEMPLATEPATH}/template.sh" #Path to BASH template
PSHELLTMP="${TEMPLATEPATH}/template.ps1" #Path to POWERSHELL template
BATTMP="${TEMPLATEPATH}/template.bat" #Path to BATCH template

#===================================================#
#                                                   #
#                     Functions                     #
#                                                   #
#===================================================#

#===================================================#
#                                                   #
#                     Test Input                    #
#                                                   #
#===================================================#

#Test Path#
#---------#
TESTPATH="${SCRIPTPATH}/${SCRIPTNAME}"

if [[ ${TESTPATH} == *"//"* ]]; then
  printf "${FAIL} Missing -p switch \n"
  exit 1
fi


#Test Arguements#
#---------------#
TESTARG="$(echo ${SCRIPTNAME} | head -c 1)"

if [[ ! ${TESTARG} = "-" ]]; then
  FILEEXTENSION="${SCRIPTNAME##*.}"

  if [[ ${FILEEXTENSION} = "sh" ]]; then
    FILEPATH="${BASHTMP}"
    SCRIPTPATH="${BASHPATH}"

  elif [[ ${FILEEXTENSION} = "ps1" ]]; then
    FILEPATH="${PSHELLTMP}"
    SCRIPTPATH="${PSHELLPATH}"

  elif [[ ${FILEEXTENSION} = "bat" ]]; then
    FILEPATH="${BATTMP}"
    SCRIPTPATH="${BATPATH}"

  else
    FILEPATH="${BASHTMP}"
    SCRIPTPATH="${BASHPATH}"
    ASSUME="1"
  fi

fi

#===================================================#
#                                                   #
#                       Swithes                     #
#                                                   #
#===================================================#

while getopts ":p:v|:s" OPT ; do
  case $OPT in

    p)
       SCRIPTPATH=$(dirname ${OPTARG})
       SCRIPTNAME=$(basename ${OPTARG})
       FILEEXTENSION="${SCRIPTNAME##*.}"

       if [[ ! -d ${SCRIPTPATH} ]]; then
         printf "${FAIL} Path does not exist \n"
         exit 1
       fi

       if [[ ${SCRIPTNAME} = ${FILEEXTENSION} ]]; then
          #printf "${WARN} No extension given. Assuming bash script \n"
          ASSUME="1"
          FILEPATH="${TEMPLATEPATH}/template.sh"

        elif [[ ${FILEEXTENSION} = "sh" ]]; then
          FILEPATH="${TEMPLATEPATH}/template.sh"
       fi



      ;;

    v)
      echo "version 1.0"
      exit 0
      ;;

    s)
      echo "mksrc path:                      ${MYPATH}"
      echo ""
      echo "Scripts top level direcotry:     ${SCRIPTPATH}"
      echo "Bash scripts direcotry:          ${BASHPATH}"
      echo "Powershell scripts direcotry:    ${PSHELLPATH}"
      echo "Batch scripts direcotry:         ${BATPATH}"
      echo ""
      echo "Template path:                   ${TEMPLATEPATH}"
      echo "Bash script template:            ${BASHTMP}"
      echo "Powershell script template:      ${PSHELLTMP}"
      echo "Batch script template:           ${BATTMP}"

      exit 0
      ;;

    :)
      echo "Arguements required: -${OPTARG}"
      exit 1
      ;;

  \?)
    echo "Invalid option: -${OPTARG}"
    exit 1
    ;;
  esac
done

#===================================================#
#                                                   #
#                   Copy Command                    #
#                                                   #
#===================================================#

if [[ -d ${SCRIPTPATH}/${SCRIPTNAME} ]]; then
  printf "${FAIL} No filename specified \n"
  exit 1

elif [[ -f ${SCRIPTPATH}/${SCRIPTNAME} ]]; then
  printf "${FAIL} File already exists \n"
  exit 1

else

  if [[ ${ASSUME} = "1" ]]; then
    printf "${WARN} No known file extension. Assuming bash script \n"
  fi

  cp ${FILEPATH} ${SCRIPTPATH}/${SCRIPTNAME}
  chmod +x ${SCRIPTPATH}/${SCRIPTNAME}
  exit 0
fi
