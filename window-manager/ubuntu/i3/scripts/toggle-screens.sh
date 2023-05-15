#!/bin/sh

# See names and resolutions of attached screens by running `xrandr`

LAPTOP_SCREEN="eDP1"
PRIMARY_SCREEN="DP2"
SECONDARY_SCREEN="DP1"
FLASH_TIME=500

if [ ! -f "/tmp/monitor_mode.dat" ]; then
	monitor_mode="ALL"
else
	monitor_mode=$(cat /tmp/monitor_mode.dat)
fi
dunstctl close

if [ "$monitor_mode" = "ALL" ]; then
	monitor_mode="EXTERNAL"
	xrandr \
		--output $LAPTOP_SCREEN --off \
		--output $PRIMARY_SCREEN --primary --mode 1920x1080 --rotate normal \
		--output $SECONDARY_SCREEN --mode 1280x720 --rotate left --right-of $PRIMARY_SCREEN
	notify-send --expire-time="$FLASH_TIME" --urgency=normal " \
  ALL\n \
* EXTERNAL\n \
  CLONES\n \
	"
elif [ "$monitor_mode" = "EXTERNAL" ]; then
	monitor_mode="CLONES"
	xrandr \
		--output $LAPTOP_SCREEN --primary --mode 1280x720 --rotate normal \
		--output $PRIMARY_SCREEN --mode 1920x1080 --rotate normal \
		--output $SECONDARY_SCREEN --same-as $PRIMARY_SCREEN
	notify-send --expire-time="$FLASH_TIME" --urgency=normal " \
  ALL\n \
  EXTERNAL\n \
* CLONES\n \
	"
else
	monitor_mode="ALL"
	xrandr \
		--output $LAPTOP_SCREEN --mode 1280x720 --rotate normal \
		--output $PRIMARY_SCREEN --primary --mode 1920x1080 --rotate normal \
		--output $SECONDARY_SCREEN --mode 1280x720 --rotate left
	notify-send --expire-time="$FLASH_TIME" --urgency=normal " \
* ALL\n \
  EXTERNAL\n \
  CLONES\n \
	"
fi

echo "${monitor_mode}" >/tmp/monitor_mode.dat
