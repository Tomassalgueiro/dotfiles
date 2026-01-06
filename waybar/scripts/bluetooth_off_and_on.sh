#!/bin/bash

# Check if bluetooth is powered on
if bluetoothctl show | grep -q "Powered: yes"; then
    bluetoothctl power off
else
    bluetoothctl power on
fi
