#!/bin/sh

. "${HOME}/.cache/wal/colors.sh"

conffile="$XDG_CONFIG_HOME/mako/config"

# Add transparency manually
bg="${background}AA"
fg="${foreground}DD"
border="${color13}88"

sed -i \
  -e "s/^background-color=.*/background-color=${bg}/" \
  -e "s/^text-color=.*/text-color=${fg}/" \
  -e "s/^border-color=.*/border-color=${border}/" \
  "$conffile"

makoctl reload
