#!/bin/bash

state=$(tailscale status --json 2>/dev/null | jq -r .BackendState)

case "$state" in
    "Running")
        echo ''
        ;;
    "Stopped")
        echo ''
        ;;
    "Starting")
        echo ''
        ;;
    "NeedsLogin"|"NeedsMachineAuth")
        echo ''
        ;;
    *)
        echo ''
        ;;
esac
