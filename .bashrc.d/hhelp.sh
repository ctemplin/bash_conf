#!/usr/bin/bash
# shellcheck shell=bash

hhelp ()
{
  local output oplines tplines
  output=$($1 -h || $1 --help)
  oplines=$(wc -l <<<"$output")
  tplines=$(tput lines)
  if (( oplines > tplines )); then
    cat <<<"$output" | less
  else
    cat <<<"$output"
  fi
  return 0
}
