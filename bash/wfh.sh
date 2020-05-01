#!/bin/bash
#
# v. 0.2
#
# TODO:
# - Add arguements for:
#   - authentication
#   - .rdp file location
#   - which monitors to use   /monitors:0,2
#
# Set liniting rules
# shellcheck disable=SC2059
# shellcheck disable=SC2010
# shellcheck disable=SC2002
# shellcheck disable=SC2162

# Colour output variables
WHITE='\033[1;37m'
RED='\033[0;91m'
GREEN='\33[92m'
YELLOW='\033[93m'
BLUE='\033[1;34m'

FAIL=${RED}'FAIL:'${WHITE}    #FAIL MESSAGES
PASS=${GREEN}'PASS:'${WHITE}  #PASS MESSAGES
INFO=${YELLOW}'INFO:'${WHITE} #INFO MESSAGES
HINT=${BLUE}'HINT:'${WHITE}   #HINT MESSAGES

# Set defaults
RDP_FILE_PATH="${HOME}/Downloads"
SESSION=$(ls -t "${RDP_FILE_PATH}" | grep .rdp | head -1)

if [[ -f "${HOME}/.wfhcredentials" ]]; then
  USERNAME=$(cat ~/.wfhcredentials | grep USERNAME | cut -d= -f 2)
  PASSWORD=$(cat ~/.wfhcredentials | grep PASSWORD | cut -d= -f 2)
  DOMAIN=$(cat ~/.wfhcredentials | grep DOMAIN | cut -d= -f 2)
else
  printf "${FAIL} No .wfhcredentials file found and no arguements passed to script\n"

  while true; do
    read -p "Do you want to create a credential file? [y/n]?" YN
    case $YN in
    [Yy]*)
      read -p 'Username: ' USERNAME
      read -p 'Password: ' PASSWORD
      read -p 'Domain: ' DOMAIN

      cat <<EOL >> "${HOME}/.wfhcredentials"
USERNAME=${USERNAME}
DOMAIN=${DOMAIN}
PASSWORD=${PASSWORD}
EOL
      break
      ;;
    [Nn]*)
      printf "No credentials saved. Exiting script\n"
      exit 1
      ;;
    *) printf "Please answer y/N\n" ;;
    esac
  done
fi

if [[ -f "${RDP_FILE_PATH}/${SESSION}" ]]; then
  xfreerdp "${RDP_FILE_PATH}/${SESSION}" /multimon /u:"${USERNAME}" /d:"${DOMAIN}" /p:"${PASSWORD}" /cert-ignore
  rm -f "${RDP_FILE_PATH}/${SESSION}"
else
  printf "${FAIL} No .rdp file found in ${RDP_FILE_PATH}\n"
  exit 1
fi
