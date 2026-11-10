#!/usr/bin/env bash
# Re-tile the focused workspace as even columns with the last two windows
# stacked top/bottom in the final column. Bound to alt-g in aerospace.toml.

set -euo pipefail

# Callers (AeroSpace, Karabiner) run with launchd's bare PATH; cover both
# Homebrew prefixes so one file works on Apple Silicon and Intel Macs.
PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

focused=$(aerospace list-windows --focused --format '%{window-id}')
tiled=$(aerospace list-windows --workspace focused --format '%{window-layout}' | grep -vc floating || true)

aerospace flatten-workspace-tree
aerospace layout tiles horizontal 2>/dev/null

# With fewer than three windows a stack would leave a single column.
if (( tiled >= 3 )); then
    aerospace focus --dfs-index $(( tiled - 1 ))
    aerospace join-with left
    aerospace focus --window-id "$focused"
fi

aerospace balance-sizes
