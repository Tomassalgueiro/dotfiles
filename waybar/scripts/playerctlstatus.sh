#!/bin/bash

status=$(playerctl status 2>/dev/null)
if [ "$status" = "Playing" ]; then
#if playectl playing show an icon
    echo ""
elif [ "$status" = "Paused" ]; then
#if paused show other
    echo "" 
else
    echo ""
#show nothing if not playing
fi
