#!/bin/sh

setxkbmap -model pc104 -layout us,ru -option grp:caps_toggle &
wmname LG3D
xset +fp /usr/share/fonts/local
xset +fp ~/.fonts
xset fp rehash
xset -dpms
xset s off
xrdb -load ~/.Xresources

sxhkd &
exec bspwm

#sxhkd -c ~/.config/sxhkd/sxhkdrc_wmutils >/dev/null 2>&1 &
#exec xwait
