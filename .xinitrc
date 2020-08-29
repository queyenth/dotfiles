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
unclutter -grav -noevents -root &

# Set wallpaper!
hsetroot -fill ~/wallpaper

# WMNAME important for some apps, idk
wmname LG3D

# Tap - escape, hold - ctrl!
#xcape -t 300 -e 'Control_L=Escape'

# Default sxhkd, which doesn't give a shit about Caps_Lock
sxhkd &

# This one SXHKD doesn't exclude caps_lock key so we can create somewhat vim-like behaviour
# When caps_lock is active, you do your WM stuff
# This allows me to create even more easy-reachable hotkeys, without needing to have Super pressed all the time
# Also allows to use Super in emacs or whatever.
#~/workspace/sxhkd/sxhkd -c ~/.config/sxhkd/lock_sxhkdrc &

exec dbus-run-session bspwm >~/.bspwm.out 2>~/.bspwm.err
