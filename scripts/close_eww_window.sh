#!/bin/sh

if [ $1 = "--window" ]; then
    window=$2
else
    window=$(~/src/eww/target/release/eww list-windows | dmenu-wl "$@")
fi
if ~/src/eww/target/release/eww active-windows | grep "$window"; then
    ~/src/eww/target/release/eww close "$window"
else
    ~/src/eww/target/release/eww open "$window"
fi
