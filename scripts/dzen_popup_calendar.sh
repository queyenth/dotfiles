#!/bin/bash

source $(dirname $0)/dzen_popup_config

WIDTH=150
LINES=8
XPOS=1765

PIPE=/tmp/calendar_pipe

trap "rm -f $PIPE" SIGTERM

TODAY=$(expr `date +'%d'` + 0)
MONTH="10#$(date +'%m')"
YEAR="10#$(date +'%Y')"

MM=${1:-"$MONTH"}
YY=${2:-"$YEAR"}
NEXT=$((MM+1))
PREV=$((MM-1))
let Y_NEXT=Y_PREV=YY
if [[ $NEXT -eq 13 ]]; then
  NEXT=1
  Y_NEXT=$((YY+1))
fi

if [[ $PREV -eq 0 ]]; then
  PREV=12
  Y_PREV=$((YY-1))
fi

if [[ "$MM" -eq "$MONTH" ]] && [[ "$YY" -eq "$YEAR" ]]; then
  CAL=$(cal | sed -re "s/^(.*[A-Za-z][A-Za-z]*.*)$/^fg($highlight)\1^fg()/;s/(^|[ ])($TODAY)($|[ ])/\1^bg($highlight2)^fg($highlight)\2^fg()^bg()\3/")
else
  CAL=$(cal "$MM" "$YY" | sed -re "s/^(.*[A-Za-z][A-Za-z]*.*)$/^fg($highlight)\1^fg()/")
fi

if [ ! -e "$PIPE" ]; then
  mkfifo "$PIPE"
  ( dzen2 -u -x $XPOS -w $WIDTH -l $LINES -sa 'c' -title-name 'popup_calendar' -fn "$FONT" ${OPTIONS} < "$PIPE"
  rm -f "$PIPE") &
fi

(
echo "$CAL"
echo "^fg($highlight)^ca(1, $0 $PREV $Y_PREV)<< Prev^ca()      ^ca(1, $0 $NEXT $Y_NEXT)Next >>^ca()^fg()"
sleep 8s
) > "$PIPE"

