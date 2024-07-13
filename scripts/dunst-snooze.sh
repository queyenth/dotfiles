#!/bin/bash

get_status() {
    if [ "$(dunstctl is-paused)" = "true" ]; then
        echo -n ""
    else
        echo -n ""
    fi

    reminder_count=$(~/scripts/emacsclient_exec.sh "(q/rem-count)")
    reminder_count=$(($reminder_count))
    if [ $reminder_count -gt 0 ]; then
        echo -n " ("$reminder_count")"
    fi
}

get_status
