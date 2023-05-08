#! /usr/bin/env bash

date "+Date: %D%nTime: %T"
echo "Volume: $(awk -F"[][]" '/dB/ { print $2 }' <(amixer sget Master))"
echo "Brightness: $(light -G)"
echo "Temperature: $(paste <(cat /sys/class/thermal/thermal_zone*/type) <(cat /sys/class/thermal/thermal_zone*/temp) | column -s $'	' -t | sed 's/\(.\)..$/.\1C°/' | awk 'FNR == 2 {print $2}')"
echo "Battery: $(acpi | awk '{print $4}')"
