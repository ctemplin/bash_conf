#!/usr/bin/bash
wttr_fetch ()
{
   # final echo is newline for stdout readability
   local RESP_CODE=$(curl -L "wttr.in/?u&format=%c+%t+%p+%w" --write-out '%{http_code}' --output ${HOME}/tmp/WTTR_RESP_BODY.txt.tmp )
   local TMP_RESP=$(cat ${HOME}/tmp/WTTR_RESP_BODY.txt.tmp)
   if [[ $RESP_CODE == 200  && $TMP_RESP =~ ^.*mph$ ]]; then
    mv ${HOME}/tmp/WTTR_RESP_BODY.txt.tmp ${HOME}/tmp/WTTR_RESP_BODY.txt
   fi
}