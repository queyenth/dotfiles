#!/bin/sh

# Fonts stuff, yay!
xset +fp /usr/share/fonts/local
xset +fp ~/.fonts
xset fp rehash

# Enable DPMS (Energy Start) features!
xset +dpms

# Enable Screen Saver!
xset s on

# Load .Xresources!
xrdb -load ~/.Xresources

# Some clipboards stuff, duh
autocutsel -fork &
autocutsel -selection PRIMARY -fork &

# Cursor stuff.
xsetroot -cursor_name left_ptr

# Set wallpaper!
hsetroot -fill ~/wallpaper

# WMNAME important for some apps, idk
wmname LG3D

# Tap - escape, hold - ctrl!
#xcape -t 300 -e 'Control_L=Escape'

# I don't know what's the difference though
exec dbus-run-session bspwm >~/.bspwm.out 2>~/.bspwm.err
#exec dbus-launch --autolaunch=$(cat /var/lib/dbus/machine-id) bspwm >~/.bspwm.out 2>~/.bspwm.err
