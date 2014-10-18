#!/bin/bash

source $(dirname $0)/dzen_popup_config

LINES=5
WIDTH=350
XPOS=1565
(echo "Diskinfo"
echo " "
for i in {sda{1,2},sdb1} ; do
  MOUNT=$(df -h | grep "$i" | awk '{gsub(/\/.*\//, "/", $6);print $6}')
  TOTAL=$(df -h | grep "$i" | awk '{print $2}')
  USED=$(df -h | grep "$i" | awk '{print $3}')
  AVAIL=$(df -h | grep "$i" | awk '{print $4}')
  USE=$(df -h | grep "$i" | awk '{gsub(/%/,"");print $5}')
  if [ "$USE" -gt 75 ]; then
    BAR=$(echo "$USE" | gdbar -bg $bar_bg -fg $warn -h 2 -w 130)
  else
    BAR=$(echo "$USE" | gdbar -bg $bar_bg -fg $bar_fg -h 2 -w 130)
  fi
  echo -e "$PAD ^fg(${label})$(printf '%-6s' $MOUNT)^fg() $BAR $USED / $TOTAL ($AVAIL free)$PAD"
done) | dzen2 -p "$TIME" -x "$XPOS" -w "$WIDTH" -l "$LINES" -sa 'l' -title-name "popup_diskinfo" -fn "$FONT" ${OPTIONS}
