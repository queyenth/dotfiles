#!/bin/sh

player_status=$(playerctl -i "firefox" status 2> /dev/null)

if [ "$player_status" = "Playing" ]; then
    echo " $(playerctl -i firefox metadata artist) - $(playerctl -i firefox metadata title)"
elif [ "$player_status" = "Paused" ]; then
    echo " $(playerctl -i firefox metadata artist) - $(playerctl -i firefox metadata title)"
else
    echo ""
fi
