#!/bin/bash

# Kill any running polybar instances
pkill -x polybar

# Give Cinnamon a moment to finish starting
sleep 2

# Launch the bar (replace 'mybar' with your bar name)
polybar example &

echo "Polybar launched."
