#!/bin/sh
source ~/.config/bspwm/config

setxkbmap -model pc104 -layout us,ru -option grp:caps_toggle &

xset +fp /usr/share/fonts/local
xset fp rehash
xsetroot -solid "${WALLCOLOR_A}"
xsetroot -cursor_name left_ptr
xrdb -load ~/.Xresources
sxhkd -c ~/.config/sxhkd/sxhkdrc_wmutils >/dev/null 2>&1 &
tinyclock &
twitch_daemon &
urxvtd &

exec xwait
