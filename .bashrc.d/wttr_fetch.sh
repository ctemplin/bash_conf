#!/usr/bin/bash
wttr_fetch ()
{
   # final echo is newline for stdout readability
   local RESP_CODE=$(curl -L wttr.in/?format="%c+%t+%p+%w" --write-out '%{http_code}' --output ${HOME}/tmp/WTTR_RESP_BODY.txt.tmp )
   if (( $RESP_CODE == 200 )); then
    mv ${HOME}/tmp/WTTR_RESP_BODY.txt.tmp ${HOME}/tmp/WTTR_RESP_BODY.txt
   fi
}