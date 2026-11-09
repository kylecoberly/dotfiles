#!/usr/bin/env bash
# Enter aerospace's resize mode only when the focused window is floating.
# Tiled windows silently ignore the binding to avoid accidental tree-weight
# changes. Bound to alt-/ in aerospace.toml.

set -euo pipefail

# Callers (AeroSpace, Karabiner) run with launchd's bare PATH; cover both
# Homebrew prefixes so one file works on Apple Silicon and Intel Macs.
PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
AEROSPACE=aerospace

layout=$("$AEROSPACE" list-windows --focused --format '%{window-layout}')

if [[ "$layout" == *floating* ]]; then
    "$AEROSPACE" mode resize
fi
