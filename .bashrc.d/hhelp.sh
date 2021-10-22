#!/usr/bin/bash
hhelp ()
{
  local output=$($1 -h || $1 --help)
  local oplines=$(wc -l <<<$output)
  local tplines=$(tput lines)
  if (( $oplines > $tplines )); then
    cat <<<$output | less
  else
    cat <<<$output
  fi
  return 0
}
