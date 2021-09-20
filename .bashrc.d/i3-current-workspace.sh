#!/usr/bin/env bash

i3-ws-num ()
{
    i3-msg -t get_workspaces | jq '.[] | select(.focused)| .num'
}

i3-wsj-file ()
{
    wsfile=~/github_repos/i3_conf/.i3/ws/workspace-`i3-ws-num`-*
    echo $wsfile
}

i3-wsj-diff ()
{
    i3-save-tree | diff -w --color `i3-wsj-file` -
}

