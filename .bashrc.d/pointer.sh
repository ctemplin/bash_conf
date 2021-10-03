#!/usr/bin/bash

get_display_dimensions ()
{
  # from https://superuser.com/questions/418699/get-display-resolution-from-the-command-line-for-linux-desktop
  read RES_X RES_Y <<<$(xdpyinfo | awk -F'[ x]+' '/dimensions:/{print $3, $4}')
}