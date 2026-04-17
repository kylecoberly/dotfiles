#!/bin/bash
# Format: "Friday, April 17th - 3:45am"

day=$(date '+%-d')
case "$day" in
    1|21|31) suffix="st" ;;
    2|22)    suffix="nd" ;;
    3|23)    suffix="rd" ;;
    *)       suffix="th" ;;
esac

dayname=$(date '+%A')
month=$(date '+%B')
time=$(date '+%-I:%M')
ampm=$(date '+%p' | tr '[:upper:]' '[:lower:]')

sketchybar --set "$NAME" label="${dayname}, ${month} ${day}${suffix} - ${time}${ampm}"
