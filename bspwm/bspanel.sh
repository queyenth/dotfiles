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
    echo $bar
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
done | dzen2 -bg '#262626' -fn '-bitstream-meslo lg m-medium-r-normal--10-*-*-*-*-*-*-*' -h 16 -ta c -p -dock -w 1050 -x 160 &
