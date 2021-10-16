#!/usr/bin/bash
wttr_fetch ()
{
   # final echo is newline for stdout readability
  ( curl --fail -s wttr.in/?format="%c+%t+%p+%w" | tee ${HOME}/tmp/WTTR_RESP_BODY.txt ) && echo;
}