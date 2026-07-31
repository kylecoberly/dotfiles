#!/bin/bash
# Lists all app names on the focused workspace, separated by ' · '.
# Subscribed to aerospace_workspace_change + front_app_switched.

# NOTE: paste/sed mangle the multi-byte '·' under launchd's default ASCII locale,
# so dedup and join in a single awk pass instead.
apps="$(aerospace list-windows --workspace focused --format '%{app-name}' 2>/dev/null \
    | awk '!seen[$0]++ { out = (out == "" ? $0 : out " · " $0) } END { print out }')"

sketchybar --set "$NAME" label="$apps"
