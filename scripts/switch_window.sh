#!/bin/bash
swaymsg mode default
input=$(wlrctl toplevel list | dmenu-wl $@)
# Xargs to cut spaces, lol.
app_id=$(echo "$input" | cut -d: -f1 | xargs)
title=$(echo "$input" | cut -d: -f2- | xargs)
if [ -n "$input" ]; then
    wlrctl toplevel activate app_id:"$app_id" title:"$title"
fi
