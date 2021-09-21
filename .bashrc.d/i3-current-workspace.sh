#!/usr/bin/env bash

i3-config-dir ()
{
    dirname `i3-msg -t get_version | jq -r .loaded_config_file_name`
}

i3-ws-num ()
{
    i3-msg -t get_workspaces | jq '.[] | select(.focused)| .num'
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

