#!/bin/bash

function statusbar {
  function desk() {
    DESKTOP=$(xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}')
    case $DESKTOP in
      0) echo "main"
        ;;
      1) echo "www"
        ;;
      2) echo "gvim"
        ;;
      3) echo "osu"
        ;;
      4) echo "five"
        ;;
      *) echo "error"
    esac
  }

  function clock() {
    time=$(date "+%e.%m %R")
    echo $time
  }

  function mem() {
    free=$(free -m | grep buffers | awk '{print $3}' | awk '/[0-9]/')
    echo $free
  }

  function temp() {
    tem=$(acpi -t | grep "Thermal 0" | awk '{print $4}')
    echo $tem
  }

  function sda() {
    dfh=$(df -h | grep "/dev/sda2" | awk '{print $3}')
    echo $dfh
  }
  
  function vol() {
    ami=$(amixer get Master | awk '/Front Left:/ {print $5}' | tr -d "[]")
    echo $ami
  }

  function ncc() {
  #  mus=$(ncmpcpp --now-playing)
    echo "TODO"
  }

  echo "^fg(#8A2F58)bspwm $(desk) ^fg(#AAAAAA) ^fg(#287373) ^fg(#914E89) ram $(mem)M ^fg(#97CBFE) sda $(sda) ^fg(#AAAAAA) ^fg(#2B7694) cpu $(temp) C ^fg(#AAAAAA) ^fg(#E5B0FF) now playing: $(ncc) ^fg(#395573) ^fg(#AAAAAA) ^fg(#47959E) vol: $(vol) ^fg(#AAAAAA) // ^fg(#FFFFFF) $(clock) ^fg(#AAAAAA)"

}

while true
do
  echo "$(statusbar)"
  sleep 0.5
done | dzen2 -bg '#262626' -fn 'meslo_lg_m-8-' -h 16 -ta r -p -w 1310 &
