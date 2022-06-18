#!/bin/bash

# shellcheck disable=SC1090

#
# Simple script to show power status information
#

version='2.0.0'

print (){
  header_colour=$1
  header_text=$2
  body_colour=$3
  body_text=$4

  printf "${header_colour}$header_text ${body_colour}$body_text\n"
}

# Source helpers script
. "$(dirname "$0")/helpers.sh"

# Print header
print "${BLUE}" "pStat - Power Status" "${WHITE}" "v$version\n"

# Get mains power status
mains_online=$(< /sys/class/power_supply/AC1/online)
mains_hid=$(< /sys/class/power_supply/AC1/device/hid)

if [[ $mains_online == 1 ]]; then
  mains_online='Online'
  mains_status_color=${GREEN}
else
  mains_online='Offline'
  mains_status_color=${YELLOW}
fi

# Print mains power status
print "${YELLOW}" 'Mains Power\n-----------'
print "${WHITE}" 'Status:' "$mains_status_color" "$mains_online"
print "${WHITE}" 'HID:' "${WHITE}" "   $mains_hid\n"

power_supplies=$(ls -1 /sys/class/power_supply/)
for power_supply in $power_supplies; do
  if [[ "$power_supply" =~ ^BAT ]]; then

    # Get battery status
    battery_hid=$(< /sys/class/power_supply/"$power_supply"/device/hid)
    . "/sys/class/power_supply/$power_supply/uevent"  2>/dev/null

    battery_capacity_multiplier=$((POWER_SUPPLY_ENERGY_FULL/POWER_SUPPLY_CAPACITY))
    battery_current_capacity=$((POWER_SUPPLY_ENERGY_NOW/battery_capacity_multiplier))

    if [ $battery_current_capacity -gt $((POWER_SUPPLY_CAPACITY/2)) ]; then
      battery_status_color=${GREEN}
    elif [ $battery_current_capacity -gt $((POWER_SUPPLY_CAPACITY/4)) ]; then
      battery_status_color=${YELLOW}
    else
      battery_status_color=${RED}
    fi


    print "${YELLOW}" "$POWER_SUPPLY_TYPE: $power_supply\n-------------"
    print "${WHITE}" 'Status:' "${YELLOW}" "       $POWER_SUPPLY_STATUS"
    print "${WHITE}" 'Capacity:' "${battery_status_color}" "     $battery_current_capacity/$POWER_SUPPLY_CAPACITY"
    print "${WHITE}" 'HID:' "${WHITE}" "          $battery_hid"
    print "${WHITE}" 'Manufacturer:' "${WHITE}" " $POWER_SUPPLY_MANUFACTURER"
    print "${WHITE}" 'Serial Number:' "${WHITE}" "$POWER_SUPPLY_SERIAL_NUMBER\n"
  fi
done
