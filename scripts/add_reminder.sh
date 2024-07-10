!/bin/bash

LOCK_FILE="/tmp/eww-reminder.lock"
EWW_BIN="$HOME/src/eww/target/release/eww"

if [[ -f "$LOCK_FILE" ]]; then
    rm "$LOCK_FILE"
fi
${EWW_BIN} close reminder_win
