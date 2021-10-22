#!/usr/bin/bash
eman ()
{
  sct-debug "eman $*";
  emacs -nw --eval "(progn (man \"$1\") (delete-window))";
}
source /usr/share/bash-completion/completions/man
complete -F _man eman
