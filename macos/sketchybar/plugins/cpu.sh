#!/bin/bash
# CPU usage %. top's -l 2 gives a more accurate delta than -l 1.
cpu="$(top -l 2 -n 0 -s 1 2>/dev/null \
    | awk '/^CPU usage/ {u=$3} END {print u}' \
    | sed 's/%//')"
# Round to int
cpu_int=${cpu%.*}
sketchybar --set "$NAME" label="${cpu_int}%"
