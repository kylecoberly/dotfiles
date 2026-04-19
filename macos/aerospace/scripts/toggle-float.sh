#!/usr/bin/env bash
# Toggle focused window between floating (unmaximized, near-centered) and tiling.
# Bound to alt-o in aerospace.toml.

set -euo pipefail

AEROSPACE=/usr/local/bin/aerospace

read -r layout fullscreen < <("$AEROSPACE" list-windows --focused --format '%{window-layout} %{window-is-fullscreen}')

# window-layout returns "floating", "h_tiles", "v_tiles", "h_accordion", "v_accordion".
if [[ "$layout" == *floating* ]]; then
    "$AEROSPACE" layout tiling
else
    [[ "$fullscreen" == "true" ]] && "$AEROSPACE" fullscreen off
    "$AEROSPACE" layout floating
    "$AEROSPACE" move-mouse window-force-center
fi
