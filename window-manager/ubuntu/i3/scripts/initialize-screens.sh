#!/bin/sh

# See names and resolutions of attached screens by running `xrandr`

LAPTOP_SCREEN="eDP-1"
PRIMARY_SCREEN="DP-2"
SECONDARY_SCREEN="DP-1"

xrandr \
	--output $LAPTOP_SCREEN --mode 1280x720
# --output $LAPTOP_SCREEN --mode 1280x720 --rotate normal --below $PRIMARY_SCREEN
# --output $PRIMARY_SCREEN --primary --mode 1920x1080 --rotate normal \
# --output $LAPTOP_SCREEN --off \
# --output $SECONDARY_SCREEN --mode 1280x720 --rotate left --right-of $PRIMARY_SCREEN
