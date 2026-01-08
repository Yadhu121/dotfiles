#!/bin/bash
cliphist list | wofi --style ~/.config/wofi/style.css --dmenu | cliphist decode | wl-copy

