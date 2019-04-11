#!/bin/bash

 #===================================================#
 #                  Connection Monkey                #
 #               Author: Steven Harsant              #
 #                  Date: 22/02/2019                 #
 #                   Version: 1.0                    #
 #===================================================#"
 #                                                   #
 #                      Notes                        #
 #  A tool simple to monitor and log internet access #
 #    hooking in with notify for push notifications  #
 #                                                   #
 #   Get notify: https://github.com/mashlol/notify   #
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

#Start Script Time#
#------------------#
START=$(date +%s)

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
USERNAME=`awk -F'[/:]' '{if ($3 >= 1000 && $3 != 65534) print $1}' /etc/passwd | head -n 1` #Logged in username
HOMEPATH="/home/${USERNAME}" #Logged in user homepath
HISTORY_FILE="${HOMEPATH}/.connection.history"

 #===================================================#
 #                                                   #
 #                      Start                        #
 #                                                   #
 #===================================================#

# Test if internet connecting is alive #
#--------------------------------------#
if nc -zw1 google.com 443 > /dev/null 2>&1
  then
    STATE=1 #Internet up
  else
    STATE=0 #Internet down
fi

# When internet is down #
#-----------------------#
if [ ${STATE} = "0" ] && [ ! -f ${HISTORY_FILE} ]; then
  echo ${START} > ${HISTORY_FILE}

fi

# When internet is up #
#---------------------#
if [ ${STATE} = "1" ] && [ -f ${HISTORY_FILE} ]; then
  DOWN_TIME=`\cat ${HISTORY_FILE}`
  UP_TIME=$(date +%s)
  DOWN_TOTAL=`expr ${UP_TIME} - ${DOWN_TIME}`

  if [[ ${DOWN_TOTAL} -gt 10 ]]; then
    rm ${HISTORY_FILE}
  fi

echo $DOWN_TOTAL

  # Format DOWN_TOTAL value #
  #-------------------------#
if [[ ${DOWN_TOTAL} -gt 10 ]]; then
    UNIT="seconds"
    if [[ ${DOWN_TOTAL} -gt 60 ]]; then
      DOWN_TOTAL=`expr ${DOWN_TOTAL} / 60`
      UNIT="minutes"
    fi
    notify -i "Downtime Detected" -t "Your internet was down for ${DOWN_TOTAL} ${UNIT}"
  fi
fi

 #===================================================#
 #                                                   #
 #                       End                         #
 #                                                   #
 #===================================================#
