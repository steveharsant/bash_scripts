#!/bin/bash

#Simple script to show battery percentage of batteries 0 & 1

#Set colour variables for output
RED='\033[0;31m'
WHITE='\033[1;37m'

printf  "${RED}BAT0 (Supplementary Battery)${WHITE}"
echo " "
upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state|to\ full|percentage"
echo " "
printf "${RED}BAT1 (Main Battery)${WHITE}"
echo " "
upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep -E "state|to\ full|percentage"
