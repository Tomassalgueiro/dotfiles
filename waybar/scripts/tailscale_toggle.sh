#!/bin/bash

status=$(tailscale status 2>&1)

if echo "$status" | grep -q "stopped"; then
    tailscale up
else
    tailscale down
fi
     
