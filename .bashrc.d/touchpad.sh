#!/usr/bin/bash

toggle_touchpad_enabled ()
{
  local DEVICE_NAME 
  DEVICE_NAME='SynPS/2 Synaptics TouchPad'

  local IS_ENABLED
  IS_ENABLED=$(xinput list-props 12 | grep -Po  '.*Device Enabled.*:\s*\K(.*)')

  if [[ $IS_ENABLED == "0" ]];
    then xinput enable  "${DEVICE_NAME}" 
    notify-send -e -t 500 "TouchPad" "ENABLED";
    fi
  if [[ $IS_ENABLED == "1" ]];
    then xinput disable "${DEVICE_NAME}"
    notify-send -e -t 500 "TouchPad" "DISABLED";
    fi

}

toggle_tapping_enabled ()
{
  local DEVICE_NAME 
  DEVICE_NAME='SynPS/2 Synaptics TouchPad'

  local IS_ENABLED
  IS_ENABLED=$(xinput list-props 12 | grep -Po  '.*Tapping Enabled\s*\(\d*\):\s*\K(.*)')

  if [[ $IS_ENABLED == "0" ]];
    then xinput set-prop "${DEVICE_NAME}" "libinput Tapping Enabled" "1" 
    notify-send -e -t 500 "Tapping" "ENABLED";
    fi
  if [[ $IS_ENABLED == "1" ]];
    then xinput set-prop "${DEVICE_NAME}" "libinput Tapping Enabled" "0"
    notify-send -e -t 500 "Tapping" "DISABLED";
    fi

}

if [[ $1 == "toggle" ]]; then toggle_touchpad_enabled;
elif [[ $1 == "tapping" ]]; then toggle_tapping_enabled;
fi
