#!/bin/bash

FILE="/tmp/swaync.fifo"

if [[ ! -p "$FILE" ]]; then
	mkfifo "$FILE"
fi

get_status() {
    if [ "$(dunstctl is-paused)" = "true" ]; then
        echo ""
    else
        echo ""
    fi
}

case "$1" in
    --toggle)
        dunstctl set-paused toggle
	echo "toggled" > "$FILE"
        ;;
    *)
        get_status
        
	tail -F "$FILE" | while read -r line ; do
            get_status
	done
        ;;
esac
