#!/usr/bin/bash

main ()
{
  local DEVICE_NAME, ICON_PATH
  DEVICE_NAME='SynPS/2 Synaptics TouchPad'
  ICON_PATH='/usr/share/icons/Papirus/128x128/devices/input-touchpad.svg'

  toggle_touchpad_enabled ()
  {
    local IS_ENABLED
    IS_ENABLED=$(xinput list-props "${DEVICE_NAME}" | grep -Po  '.*Device Enabled.*:\s*\K(.*)')

    if [[ $IS_ENABLED == "0" ]];
      then xinput enable  "${DEVICE_NAME}" 
      notify-send -e -t 1500 -i "${ICON_PATH}" "TouchPad" "ENABLED";
    fi
    if [[ $IS_ENABLED == "1" ]];
      then xinput disable "${DEVICE_NAME}"
      notify-send -e -t 1500 -i "${ICON_PATH}" "TouchPad" "DISABLED";
    fi

  }

  # Toggle between tapping enabled with two-finger scrolling and
  # tapping disabled with edge scrolling enabled
  toggle_tapping_enabled ()
  {
    local IS_ENABLED
    IS_ENABLED=$(xinput list-props "${DEVICE_NAME}" | grep -Po  '.*Tapping Enabled\s*\(\d*\):\s*\K(.*)')

    if [[ $IS_ENABLED == "0" ]];
      then xinput set-prop "${DEVICE_NAME}" "libinput Tapping Enabled" "1" && \
        xinput set-prop  "${DEVICE_NAME}" "libinput Scroll Method Enabled" "1" "0" "0"
      notify-send -e -t 1500 -i "${ICON_PATH}" "Tapping" "ENABLED";
    fi
    if [[ $IS_ENABLED == "1" ]];
      then xinput set-prop "${DEVICE_NAME}" "libinput Tapping Enabled" "0" && \
        xinput set-prop  "${DEVICE_NAME}" "libinput Scroll Method Enabled" "0" "1" "0"
      notify-send -e -t 1500 -i "${ICON_PATH}" "Tapping" "DISABLED";
    fi

  }

  if [[ $1 == "toggle" ]]; then toggle_touchpad_enabled;
  elif [[ $1 == "tapping" ]]; then toggle_tapping_enabled;
  fi
}

if [[ $1 ]]; then main "$1"; fi
