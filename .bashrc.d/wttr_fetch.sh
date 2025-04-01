#!/usr/bin/bash
wttr_fetch ()
{
   local RESP_CODE TMP_RESP
   # WTTR_LOC is an env var
   # final echo is newline for stdout readability
   RESP_CODE=$(curl -L "wttr.in/${WTTR_LOC}?u&format=%l+%c+%t+%p+%w" --write-out '%{http_code}' --output "${HOME}"/tmp/WTTR_RESP_BODY.txt.tmp )
   TMP_RESP=$(cat "${HOME}"/tmp/WTTR_RESP_BODY.txt.tmp)
   if [[ $RESP_CODE == 200  && $TMP_RESP =~ ^.*mph$ ]]; then
    mv "${HOME}"/tmp/WTTR_RESP_BODY.txt.tmp "${HOME}"/tmp/WTTR_RESP_BODY.txt
   fi
}