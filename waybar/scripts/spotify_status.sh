#!/bin/bash

CACHE="/tmp/waybar_spotify_last_active"

status=$(playerctl --player=spotify status 2>/dev/null)

if [ "$status" = "Playing" ]; then
  date +%s > "$CACHE"
  playerctl --player=spotify metadata \
    --format '<span foreground="#1DB954"></span>  {{artist}} - {{title}}'
  exit 0
fi

if [ "$status" = "Paused" ] && [ -f "$CACHE" ]; then
  last_active=$(cat "$CACHE")
  now=$(date +%s)

  if [ $((now - last_active)) -le 30 ]; then
    playerctl --player=spotify metadata \
      --format '<span foreground="#1DB954"></span>  {{artist}} - {{title}}'
    exit 0
  fi
fi

exit 1

