#!/usr/bin/env bash
# Enter aerospace's resize mode only when the focused window is floating.
# Tiled windows silently ignore the binding to avoid accidental tree-weight
# changes. Bound to alt-/ in aerospace.toml.

set -euo pipefail

AEROSPACE=/usr/local/bin/aerospace

layout=$("$AEROSPACE" list-windows --focused --format '%{window-layout}')

if [[ "$layout" == *floating* ]]; then
    "$AEROSPACE" mode resize
fi
