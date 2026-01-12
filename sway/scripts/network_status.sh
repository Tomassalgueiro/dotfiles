#!/bin/bash

# Check if any device is in the 'connected' state
if nmcli device status | grep -E "(wifi|ethernet)" | grep -q " connected"; then
    echo "conn"
else
    echo "disc"
fi
