#!/usr/bin/env bash

i3-list-workspaces ()
{
    i3-msg -t get_workspaces | jq  -cr '.[] | [.num, .name]'
}

i3-config-dir ()
{
    dirname "$(i3-msg -t get_version | jq -r .loaded_config_file_name)"
}

i3-ws-num ()
{
    i3-msg -t get_workspaces | jq '.[] | select(.focused)| .num'
}

i3-ws-name ()
{
    i3-msg -t get_workspaces | jq -r '.[] | select(.focused)| .name'
}

i3-ws-text ()
{
    i3-msg -t get_workspaces | jq  -cr '.[] | select(.focused) | [.num, (.name | match( "(?>\\d+:\\P{In_Basic_Latin}*)\\s*\\K([\\p{ASCII}\\s]+)") | .captures[0].string )] | .[1] '
    # i3-msg -t get_workspaces | jq '.[] | select(.focused)| .name | scan( "(?>\\d+:\\P{In_Basic_Latin}?)\\K[\\p{ASCII}\\s]+" )'
}

i3-focused-node ()
{
    i3-msg -t get_tree | jq ' recurse((.nodes, .floating_nodes)[]) | select(.focused == true)'
}

i3-focused-node-floating ()
{
    i3-msg -t get_tree | jq -j ' recurse((.nodes, .floating_nodes)[]) | select(.focused == true) | .floating'
}

i3-focused-node-parent ()
{
    i3-msg -t get_tree | jq -r ' getpath(path(recurse((.nodes, .floating_nodes)[]) | select(.focused == true))[:-2]) '
}

i3-focused-node-percent ()
{
    i3-focused-node | jq -j ' .percent '
}

i3-focused-node-ppts ()
{
    i3-focused-node-percent | jq -j '( . * 100 ) | round '
}

i3-focused-node-display ()
{
    i3-focused-node | jq -j ' .output'
}

i3-wsj-file ()
{
    local WSTEXT
    if [ -z "$1" ]; then WSTEXT=$(i3-ws-text); else WSTEXT=$1; fi
    wsfile="$(i3-config-dir)/ws/workspace-${WSTEXT}.jsonc"
    if [ -f "$wsfile" ]
    then
        echo "$wsfile"
    else
        echo 'No file matching: ' "$wsfile"
        return 1
    fi
}

i3-wsj-diff ()
{
    local WSFILE
    WSFILE=$(i3-wsj-file "$(i3-ws-text)")
    if [ ! "$WSFILE" == 0 ]
    then
        i3-save-tree | diff -w --color "$WSFILE" -
    else
        echo "$WSFILE"
    fi
}

i3-window-has-matching-mark ()
{
    local MARK_PAT
    MARK_PAT="$1"
    i3-focused-node | jq -r --arg mark_pat "$MARK_PAT" '. | reduce .marks[] as $i (false; . or ( $i | test($mark_pat)))'

}

i3-notify-has-mark ()
{
    local MARK_PAT TRUE_MSG FALSE_MSG HAS_MATCH
    MARK_PAT="$1"
    TRUE_MSG=${2:-"True"}
    FALSE_MSG=${3:-"False"}
    HAS_MATCH=$(i3-window-has-matching-mark "$MARK_PAT")
    if [ "$HAS_MATCH" == true ]; then 
        notify-send -t 1000 -u critical "$TRUE_MSG"
    else
        notify-send -t 1000 -u normal   "$FALSE_MSG"
    fi
}
