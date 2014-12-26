#!/bin/sh
source ~/.config/bspwm/config

setxkbmap -model pc104 -layout us,ru -option grp:caps_toggle &
wmname LG3D
xset +fp /usr/share/fonts/local
xset +fp ~/.fonts
xset fp rehash
xset -dpms
xset s off
xsetroot -solid "${WALLCOLOR_A}"
xsetroot -cursor_name left_ptr
xrdb -load ~/.Xresources

unclutter -grav -noevents -root &

tinyclock &
twitch_daemon &
urxvtd &

sxhkd &
exec bspwm

#sxhkd -c ~/.config/sxhkd/sxhkdrc_wmutils >/dev/null 2>&1 &
#exec xwait
