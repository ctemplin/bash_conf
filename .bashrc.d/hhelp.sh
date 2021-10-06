#!/usr/bin/bash
hhelp ()
{
  $1 -h || $1 --help
}
complete -c hhelp
