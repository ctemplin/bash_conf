#!/usr/bin/bash
locatedir ()
{
  ls -dp1 --group-directories-first "$(locate -eb \\"${1}")";
}
