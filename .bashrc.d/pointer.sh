#!/usr/bin/bash

get_display_dimensions ()
{
  # shellcheck disable=SC2034  # Unused variables left for readability
  # from https://superuser.com/questions/418699/get-display-resolution-from-the-command-line-for-linux-desktop
  read -r RES_X RES_Y <<<"$(xdpyinfo | awk -F'[ x]+' '/dimensions:/{print $3, $4}')"
}

warp_pointer_zero ()
{
  wmp -a 0 0
}

warp_pointer_con_center ()
{
  # shellcheck source=/dev/null
  source ~/.bashrc.d/i3-current-workspace.sh
  local WIN_ID XINFO
  WIN_ID="$(i3-focused-node | jq .window)"
  XINFO="$(xwininfo -id "${WIN_ID}")"
  WIN_X=$(/usr/bin/grep -Po "^\s*Absolute\supper-left\sX\:\s*\K(\w*).*$"<<<"${XINFO}")
  WIN_Y=$(/usr/bin/grep -Po "^\s*Absolute\supper-left\sY\:\s*\K(\w*.*$)"<<<"${XINFO}")
  WIN_W=$(/usr/bin/grep -Po "^\s*Width\:\s*\K(\w*).*$"<<<"${XINFO}")
  WIN_H=$(/usr/bin/grep -Po "^\s*Height\:\s*\K(\w*).*$"<<<"${XINFO}")
  wmp -a $(( WIN_X + WIN_W / 2 )) $(( WIN_Y + WIN_H / 2 )) 
}

if [[ $1 == "zero" ]]; then warp_pointer_zero; fi
if [[ $1 == "con_center" ]]; then warp_pointer_con_center; fi