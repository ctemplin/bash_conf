#!/usr/bin/bash
agrep ()
{
  local PRE=''
  local TERMS=$1
  if [[ $1 == "-h" ]]; then
    echo "Usage: agrep [-a] <term>"
    echo "List aliases that begin with <term>"
    echo "  -a, <term> appears anywhere in alias definition"
  fi

  if [[ $1 == "-a" ]]; then PRE='.*'; TERMS=$2; fi
  alias | /usr/bin/grep -Po "^alias\s\K${PRE}(${TERMS}).*"
}
