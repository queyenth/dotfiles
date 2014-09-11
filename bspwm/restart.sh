#! /bin/sh
killall dzen2
pkill bspanel.sh
pkill panel
pkill stalonetray

stalonetray --geometry 10x1-0+0 --icon-gravity E --grow-gravity E -bg "#262626" -i 14 -d all &
./panel &
./bspanel.sh &
