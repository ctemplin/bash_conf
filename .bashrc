#
# ~/.bashrc
#
# shellcheck shell=bash

# Don't run for non-interactive shells
# NOTE: /etc/bash.bashrc (which sources this file) also starts with with this
# check. Harmless but redundant?
[[ $- != *i* ]] && return

colors() {
  local fgc bgc vals seq0

  #shellcheck disable=SC2016
  printf "Color escapes are %s\n" '\e[${value};...;${value}m'
  printf "Values 30..37 are \e[33mforeground colors\e[m\n"
  printf "Values 40..47 are \e[43mbackground colors\e[m\n"
  printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

  # foreground colors
  for fgc in {30..37}; do
    # background colors
    for bgc in {40..47}; do
      fgc=${fgc#37} # white
      bgc=${bgc#40} # black

      vals="${fgc:+$fgc;}${bgc}"
      vals=${vals%%;}

      seq0="${vals:+\e[${vals}m}"
      printf "  %-9s" "${seq0:-(default)}"
      # shellcheck disable=SC2059
      printf " ${seq0}TEXT\e[m"
      # shellcheck disable=SC2059
      printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
    done
    echo; echo
  done
}

export WTTR_LOC="Austin"

export BASH_COMPLETION_USER_DIR=${HOME}/.bash-completion
export BASH_COMPLETION_USER_FILE=${BASH_COMPLETION_USER_DIR}/bash_completion
# shellcheck source=/dev/null
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# PROMPT_COMMAND is run before every redraw of $PS1
case ${TERM} in
  xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
    # First line sets conditional to display non-0 return val in $PS1.
    # Second line sets conditional to display non-0 background jobs count. 
    # Third line sets window title.
    PROMPT_COMMAND='\
    RET=$?; if (( RET == 0 )); then RET=""; else RET="[$RET]"; fi;\
    JC=$(jobs -p | wc -l); if (( JC == 0 )); then JC=""; else JC="{$JC}"; fi;\
    echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
    ;;
  screen*)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
    ;;
esac
DEFAULT_PROMPT=$PROMPT_COMMAND
sct ()
{
    STR="$*"
    if (( ${#STR} > 0 )) ; then
        PROMPT_COMMAND='echo -ne "\033]0;${STR}\007"'
    else
        echo "error: no title provided"
    fi
}
# Variation of function above with DEBUG abuse.
# Allows title change to take effect before calling function returns.
sct-debug ()
{
    STR="$*"
    if (( ${#STR} > 0 )) ; then
        trap 'echo -ne "\033]0;${STR}\007"' DEBUG;
    else
        echo "error: no title provided"
    fi
}
alias set-custom-title='sct'
cct ()
{
    PROMPT_COMMAND=$DEFAULT_PROMPT
}
alias clear-custom-title='cct'

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
  && type -P dircolors >/dev/null \
  && match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
  # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
  if type -P dircolors >/dev/null ; then
    if [[ -f ~/.dir_colors ]] ; then
      eval "$(dircolors -b ~/.dir_colors)"
    elif [[ -f /etc/DIR_COLORS ]] ; then
      eval "$(dircolors -b /etc/DIR_COLORS)"
    fi
  fi

  # TS (TEXT DECORATION): 01=bold 02=? 03=italics 04=underline 05=blinking
  # \[\033[TS;FG;BGm]
  if [[ ${EUID} == 0 ]] ; then
    PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
  else
    PS1='[\[\033[03;33m\]\u@\h\[\033[m\] \[\033[01;35m\]${JC}\[\033[00m\]\[\033[01;31m\]${RET}\[\033[00m\]\W]\$ '
  fi

else
  if [[ ${EUID} == 0 ]] ; then
    # show root@ when we don't have colors
    PS1='\u@\h \W \$ '
  else
    PS1='\u@\h \w \$ '
  fi
fi

unset use_color safe_term match_lhs sh

alias i3-socket='i3 --get-socketpath'
alias ls='/usr/bin/ls --color=auto -F'
alias sl='/usr/bin/ls --color=auto -F'
alias ll='/usr/bin/ls -l --color=auto -F'
alias la='/usr/bin/ls -Al --color=auto -F'
alias lsd='/usr/bin/ls -dl --color=auto */'
alias lsl='/usr/bin/ls -Altr --color=auto -F'
alias grep='grep --color=auto -d skip'
alias egrep='grep -E --color=auto'
alias fgrep='grep -F --color=auto'
# shellcheck disable=SC2089
FONT_CMD="printf \'\\\33]50;%s\\\007\' \"$(xrdb -query -get URxvt.font)\""
# shellcheck disable=SC2139
alias font="${FONT_CMD}"                  # C-M-e expand and edit
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias eixt="exit"
alias free='free -m'                      # show sizes in MB
alias ggv='gh gist view'
alias more=less
alias octopi=/usr/bin/octopi              # full path required for some reason
alias pacman='pacman --color=auto'
alias yay='yay --color=auto'
alias sbrc='source ~/.bashrc'
alias h='hhelp'
alias pg='pgrep -i'
alias pga='pgrep -a -i'
alias i3errorlog='less -e +G `i3 --get-socketpath | sed "s/ipc-socket/errorlog/"`'
alias withless='$(builtin history -p !!)|less'
alias weather='wttr_fetch'
alias cron-status-log='systemctl status cronie'
alias iw-interface='ls --indicator-style=none /sys/class/ieee80211/*/device/net/'
# shellcheck disable=SC2142
alias subnet-mask='ifconfig `iw-interface` | awk '\''/netmask/{ print $4;}'\'' | tee /dev/tty | xclip && echo "copied via xclip"'
alias qemu-mj='qemu-system-x86_64 --hda qemu-disk-manjaro-i3-shade-test.img -m 4G --cdrom manjaro-i3-21.1.2-minimal-210907-linux513.iso --boot d'
alias type='type -a'
alias journalctl-boot='journalctl --system --boot=0 --priority=4 -r'

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize
shopt -s expand_aliases
shopt -s cdspell
shopt -s dotglob
shopt -s extglob
shopt -s hostcomplete
# Enable history appending instead of overwriting.  #139609
shopt -s histappend
# export HISTCONTROL=ignorespace|ignoredups|ignoreboth
export HISTCONTROL=ignoreboth

# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

export NO_AT_BRIDGE=1

# Disable XON/XOFF so Ctrl-s does forward incremental search
stty -ixon

if [ -d ~/.bashrc.d ]; then
    for SCRIPT in ~/.bashrc.d/*; do
        # shellcheck source=/dev/null
        . "${SCRIPT}"
    done
    unset SCRIPT
fi

PCOM=$(ps -q $PPID -o comm=)
if [[ $PCOM == urxvtd ]]; then echo "$PPID running in $PCOM daemon "; else echo "$PPID running in separate $PCOM process"; fi
