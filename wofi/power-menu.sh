#!/bin/bash

chosen=$(wofi --show dmenu --no-persistent \
  --prompt '' --hide-scroll \
  --width 200 --height 180 \
  --cache-file /dev/null \
  < <(echo -e "🔒  Lock\n  Poweroff\n🔁  Reboot\n🚪  Logout"))

case "$chosen" in
  "🔒  Lock")     loginctl lock-session ;;
  "  Poweroff")  systemctl poweroff ;;
  "🔁  Reboot")   systemctl reboot ;;
  "🚪  Logout")   hyprctl dispatch exit ;;
esac

style=/home/Yadhu/.config/wofi/style.css
