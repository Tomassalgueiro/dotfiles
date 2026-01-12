#!/bin/bash

if playerctl status > /dev/null 2>&1; then
	if [[ $(playerctl status) == "Playing" ]]
	then
		echo "Now playing -" $(playerctl metadata --format='{{ title }} by {{ artist }}')
	fi
else
	echo ""
fi
