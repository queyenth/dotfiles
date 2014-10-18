#!/bin/bash

source $(dirname $0)/dzen_popup_config

LINES=5
WIDTH=230
XPOS=1685

KERNEL=$(uname -r)
UPTIME=$(uptime | sed 's/.* up *//' | sed 's/[0-9]* us.*//' | sed 's/ day, /d /' | sed 's/ days, /d /' | sed 's/:/h /' | sed 's/ min//' | sed 's/,/m/' | sed 's/  / /')
PACKAGES=$(pacman -Q | wc -l)
UPDATE=$(awk '/upgraded/ {line=$0;} END { $0=line; gsub(/[\[\]]/, "",$0); printf "%s %s",$1,$2;}' /var/log/pacman.log)

(
echo "Sysinfo"
echo "$PAD ^fg("$label")Uptime:^fg() $UPTIME "
echo "$PAD ^fg("$label")Kernel:^fg() $KERNEL"
echo "$PAD ^fg("$label")Pacman:^fg() $PACKAGES packages"
echo "$PAD ^fg("$label")Last updated on:^fg() $UPDATE $PAD"
) | dzen2 -p "$TIME" -x "$XPOS" -w "$WIDTH" -l "$LINES" -sa 'l' -title-name 'popup_sysinfo' -fn "$FONT" ${OPTIONS}
