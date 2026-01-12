#!/bin/bash

WALLPAPER_DIR=~/Wallpaper
STATE_FILE=~/.cache/wallpaper_list.txt

while true; do
  # Ensure cache dir exists
  mkdir -p "$(dirname "$STATE_FILE")"

  # If state file doesn't exist or is empty, (re)populate it
  if [[ ! -s "$STATE_FILE" ]]; then
    find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' \) |
      shuf >"$STATE_FILE"
  fi

  # Take the first wallpaper from the list
  WALLPAPER=$(head -n 1 "$STATE_FILE")
  cp "$WALLPAPER" ~/.cache/current_wallpaper.png

  swaymsg "output * bg '$WALLPAPER' fill"
  # Remove it from the list (so it won't be reused until rotation is complete)
  sed -i '1d' "$STATE_FILE"

  sleep 1800
done
#pkill swaybg
#sleep 0.5
# Set wallpaper
#swaybg -i "$WALLPAPER" -m fill &
#awww img $WALLPAPER --transition-fps 60 --transition-step 255 --transition-type any
