#!/bin/bash
# Lists all app names on the focused workspace, separated by ' · '.
# Subscribed to aerospace_workspace_change + front_app_switched.

apps="$(aerospace list-windows --workspace focused --format '%{app-name}' 2>/dev/null \
    | awk '!seen[$0]++' \
    | paste -sd '·' - \
    | sed 's/·/ · /g')"

sketchybar --set "$NAME" label="$apps"
