#!/usr/bin/bash
yay_open_url ()
{
  yay -Qi "${@: -1}" | sed -nr 's/^URL\s*:\s*(\S*).*$/\1/p' | xargs xdg-open
}
