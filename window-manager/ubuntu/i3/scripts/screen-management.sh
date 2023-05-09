#!/bin/sh

LAPTOP_SCREEN="eDP-1"
PRIMARY_SCREEN="DP-1"
SECONDARY_SCREEN="DP-2"

if [ ! -f "/tmp/monitor_mode.dat" ]; then
	monitor_mode="all"
else
	monitor_mode=$(cat /tmp/monitor_mode.dat)
fi

if [ "$monitor_mode" = "all" ]; then
	monitor_mode="EXTERNAL"
	xrandr \
		--output $LAPTOP_SCREEN --off \
		--output $PRIMARY_SCREEN --primary --mode 1920x1080 --pos 0x0 --rotate normal \
		--output $SECONDARY_SCREEN --mode 1920x1080 --pos 0x0 --rotate normal --right-of $PRIMARY_SCREEN
elif [ "$monitor_mode" = "EXTERNAL" ]; then
	monitor_mode="CLONES"
	xrandr \
		--output $LAPTOP_SCREEN --primary --mode 1920x1080 --pos 0x0 --rotate normal \
		--output $PRIMARY_SCREEN --mode 1920x1080 --pos 0x0 --rotate normal \
		--output $SECONDARY_SCREEN --same-as $PRIMARY_SCREEN
else
	monitor_mode="all"
	xrandr \
		--output $LAPTOP_SCREEN --mode 1920x1080 --pos 0x0 --rotate normal \
		--output $PRIMARY_SCREEN --primary --mode 1920x1080 --pos 0x0 --rotate normal \
		--output $SECONDARY_SCREEN --mode 1920x1080 --pos 0x0 --rotate left
fi

echo "${monitor_mode}" >/tmp/monitor_mode.dat
