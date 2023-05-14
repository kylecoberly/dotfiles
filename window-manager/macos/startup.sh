#!/bin/bash

# Put this script in System Preferences → Users & Groups → Login Items

yabai --stop-service
yabai --start-service
skhd --stop-service
skhd --start-service
sudo yabai --load-sa
