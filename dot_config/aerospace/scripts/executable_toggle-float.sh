#!/usr/bin/env bash
# Toggle focused window between floating (unmaximized, near-centered) and tiling.
# Bound to alt-o in aerospace.toml.

set -euo pipefail

# Callers (AeroSpace, Karabiner) run with launchd's bare PATH; cover both
# Homebrew prefixes so one file works on Apple Silicon and Intel Macs.
PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
AEROSPACE=aerospace

read -r layout fullscreen < <("$AEROSPACE" list-windows --focused --format '%{window-layout} %{window-is-fullscreen}')

# window-layout returns "floating", "h_tiles", "v_tiles", "h_accordion", "v_accordion".
if [[ "$layout" == *floating* ]]; then
    "$AEROSPACE" layout tiling
else
    [[ "$fullscreen" == "true" ]] && "$AEROSPACE" fullscreen off
    "$AEROSPACE" layout floating
    "$AEROSPACE" move-mouse window-force-center
fi
