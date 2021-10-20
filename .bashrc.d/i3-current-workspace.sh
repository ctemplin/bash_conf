#!/usr/bin/env bash

i3-list-workspaces ()
{
    i3-msg -t get_workspaces | jq  -cr '.[] | [.num, .name]'
}

i3-config-dir ()
{
    dirname `i3-msg -t get_version | jq -r .loaded_config_file_name`
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
    i3-msg -t get_workspaces | jq  -cr '.[] | select(.focused) | [.num, (.name | match( "(?>\\d+:\\P{In_Basic_Latin}*)\\K([\\p{ASCII}\\s]+)") | .captures[0].string )] | .[1] '
    # i3-msg -t get_workspaces | jq '.[] | select(.focused)| .name | scan( "(?>\\d+:\\P{In_Basic_Latin}?)\\K[\\p{ASCII}\\s]+" )'
}

i3-con-id ()
{
    i3-msg -t get_tree | jq -j ' recurse((.nodes, .floating_nodes)[]) | select(.focused == true) | .id '
}

i3-wsj-file ()
{
    local WSNUM
    if [ -z "$1" ]; then WSNUM=$(i3-ws-num); else WSNUM=$1; fi
    wsfile=$(i3-config-dir)/ws/workspace-${WSNUM}-*
    if [ -f $wsfile ]
    then
        echo $wsfile
    else
        echo 'No file matching: ' $wsfile
        return 1
    fi
}

i3-wsj-diff ()
{
    local WSNUM
    if [ -z "$1" ]; then WSNUM=$(i3-ws-num); else WSNUM=$1; fi
    local WSFILE
    WSFILE=`i3-wsj-file $WSNUM`
    if [ "$?" == 0 ]
    then
        i3-save-tree | diff -w --color $WSFILE -
    else
        echo $WSFILE
    fi
    
}

