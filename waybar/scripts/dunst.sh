#!/usr/bin/sh

get_status() {
    if [ "$(dunstctl is-paused)" = "true" ]; then
        echo -n "<big></big> "
    else
        echo -n "<big></big> "
    fi
    echo -n $(dunstctl count history)

    reminder_count=$(~/scripts/emacsclient_exec.sh "(q/rem-count)")
    reminder_count=$(($reminder_count))
    if [ $reminder_count -gt 0 ]; then
        echo -n " ("$reminder_count")"
    fi
    echo
}

# text
get_status
# tooltip
~/scripts/emacsclient_exec.sh "(q/rem-show)" | tr '\n' '\r'
