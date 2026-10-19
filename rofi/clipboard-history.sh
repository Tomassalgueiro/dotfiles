#!/usr/bin/env bash

LOG_FILE="$HOME/.cache/links.txt"
EMOJI="📋" # You can change this to 📄, ✂️, 📝, etc.

if [[ ! -f "$LOG_FILE" ]]; then
    notify-send "Clipboard History" "File not found: $LOG_FILE"
    exit 1
fi

# Parse entries into single-line previews prepended with an emoji
SELECTED_INDEX=$(awk -v emoji="$EMOJI" '
  /^##### .* #####$/ {
    if (preview != "") {
      gsub(/\n/, " ↵ ", preview)
      print emoji "  " preview
    }
    preview = ""
    next
  }
  {
    if ($0 != "") {
      preview = (preview == "" ? "" : preview "\n") $0
    }
  }
  END {
    if (preview != "") {
      gsub(/\n/, " ↵ ", preview)
      print emoji "  " preview
    }
  }
' "$LOG_FILE" | tac | rofi -dmenu -i -p "Copy" -format "i" -theme clipboard-history.rasi)
		
# Exit if cancelled/Esc pressed
[[ -z "$SELECTED_INDEX" ]] && exit 0

# Retrieve exact raw multi-line content for selected index and send to wayland clipboard
awk -v target="$((SELECTED_INDEX + 1))" '
  /^##### .* #####$/ {
    if (raw != "") {
      count++
      if (count == target) {
        printf "%s", raw
        exit
      }
    }
    raw = ""
    next
  }
  {
    if ($0 != "") {
      raw = (raw == "" ? "" : raw "\n") $0
    }
  }
  END {
    if (raw != "") {
      count++
      if (count == target) {
        printf "%s", raw
      }
    }
  }
' <(tac "$LOG_FILE") | wl-copy
