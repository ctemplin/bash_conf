#!/usr/bin/bash

get_display_dimensions ()
{
  # shellcheck disable=SC2034  # Unused variables left for readability
  # from https://superuser.com/questions/418699/get-display-resolution-from-the-command-line-for-linux-desktop
  read -r RES_X RES_Y <<<"$(xdpyinfo | awk -F'[ x]+' '/dimensions:/{print $3, $4}')"
}

warp_pointer_zero ()
{
  xdotool mousemove 0 0
}

warp_pointer_con_center ()
{
  if command -v xdotools > /dev/null 2>&1; then
    echo "xdotool"
    eval "$(xdotool getwindowfocus getwindowgeometry --shell)" && xdotool mousemove $((X + WIDTH/2)) $((Y + HEIGHT/2))
    return;
  else
    # Get focused window ID (decimal)
    WINDOW=$(xprop -root _NET_ACTIVE_WINDOW | cut -d' ' -f5)

    # Get window geometry
    GEOMETRY=$(xwininfo -id "$WINDOW" | grep -E "(Absolute upper-left|Width:|Height:)")

    # Parse geometry values
    X=$(echo "$GEOMETRY" | grep "Absolute upper-left X" | awk '{print $4}')
    Y=$(echo "$GEOMETRY" | grep "Absolute upper-left Y" | awk '{print $4}')
    WIDTH=$(echo "$GEOMETRY" | grep "Width:" | awk '{print $2}')
    HEIGHT=$(echo "$GEOMETRY" | grep "Height:" | awk '{print $2}')

    # Calculate center and move mouse
    CENTER_X=$((X + WIDTH/2))
    CENTER_Y=$((Y + HEIGHT/2))

    if command -v xwarppointer > /dev/null 2>&1; then
      echo xwarppointer
      xwarppointer none $CENTER_X $CENTER_Y
    elif command -v swarp > /dev/null 2>&1; then
      echo "swarp"
      swarp $CENTER_X $CENTER_Y
    fi
  fi
}

if [[ $1 == "zero" ]]; then warp_pointer_zero; fi
if [[ $1 == "con_center" ]]; then warp_pointer_con_center; fi