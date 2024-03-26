#!/bin/zsh

# Put this script in System Preferences → Users & Groups → Login Items

sh -c "yabai --stop-service"
sh -c "yabai --start-service"
sh -c "skhd --stop-service"
sh -c "skhd --start-service"
sh -c "sudo yabai --load-sa"
exit 0
