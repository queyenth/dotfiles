#!/bin/sh

xset +fp /usr/share/fonts/local
xset +fp ~/.fonts
xset fp rehash
xset +dpms

xset s on
xrdb -load ~/.Xresources

autocutsel -fork &
autocutsel -selection PRIMARY -fork &

xsetroot -cursor_name left_ptr

dunst &
hsetroot -fill ~/wallpaper

#xcape -t 300 -e 'Control_L=Escape'

wmname LG3D

sxhkd &
exec bspwm >~/.bspwm.out 2>~/.bspwm.err
