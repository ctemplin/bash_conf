#!/usr/bin/bash
# Change to the physical directory and echo new working directory.
# Useful to quickly confirm a suspected symlink dir.
cdf () 
{ 
    cd -P "$1" && pwd
    return $?
}
