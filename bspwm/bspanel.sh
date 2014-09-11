#!/bin/bash

function statusbar {

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

  function batt() {
    bat=$(cat /sys/class/power_supply/BAT0/capacity)
    s="«"
    bar=""
    case $bat in
      100)
        bar=""
        ;;
      [0-5])
        bar="\f8$s$s$s$s$s$s$s$s$s"
        ;;
      [5-9])
        bar="\f3$s\f8$s$s$s$s$s$s$s$s"
        ;;
      [1-2]*)
        bar="$s$s\f8$s$s$s$s$s$s$s"
        ;;
      3*)
        bar="$s$s$s\f8$s$s$s$s$s$s"
        ;;
      4*)
        bar="$s$s$s$s\f8$s$s$s$s$s"
        ;;
      5*)
        bar="$s$s$s$s$s\f8$s$s$s$s"
        ;;
      6*)
        bar="$s$s$s$s$s$s\f8$s$s$s"
        ;;
      7*)
        bar="$s$s$s$s$s$s$s\f8$s$s"
        ;;
      8*)
        bar="$s$s$s$s$s$s$s$s\f8$s"
        ;;
      *)
        bar="$s$s$s$s$s$s$s$s$s"
        ;;
    esac
    echo "$bar"
  }

  function ncc() {
    mus=$(mpc current)
    echo $mus
  }

  echo "^fg(#AAAAAA) ^fg(#914E89) ram $(mem)M ^fg(#97CBFE) sda $(sda) ^fg(#AAAAAA) ^fg(#2B7694) cpu $(temp) C ^fg(#AAAAAA) ^fg(#E5B0FF) now playing: $(ncc) ^fg(#395573) ^fg(#AAAAAA) ^fg(#47959E) vol: $(vol) ^fg(#AAAAAA) ^fg(#5E468C) bat: $(batt) ^fg(#AAAAAA) // ^fg(#FFFFFF) $(clock) ^fg(#AAAAAA)"

}

while true
do
  echo "$(statusbar)"
  sleep 0.5
done | dzen2 -bg '#262626' -fn '-bitstream-meslo lg m-medium-r-normal--8-*-*-*-*-*-*-*' -h 16 -ta c -p -dock -w 1050 -x 160 &
