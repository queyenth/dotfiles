#! /bin/sh

source $(dirname $0)/config

if [ $(pgrep -cx bspwm_panel.sh) -gt 1 ] ; then
    printf "%s\n" "The panel is already running." >&2
    exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"

bspc control --subscribe > "$PANEL_FIFO" &

xtitle -sf 'T%s' > "$PANEL_FIFO" &
conky -c ~/conky/bspwm_toggle_conkyrc > "$PANEL_FIFO" &

bspwm_panel_bar.sh < "$PANEL_FIFO" \
     | lemonbar -p \
           -g "$PANEL_GEOMETRY" \
           -f "$FONT1" \
           -f "$FONT2" \
           -B "$BACKGROUND" \
           -F "$FOREGROUND" \
           | while read line; do eval "$line"; done &
wait

