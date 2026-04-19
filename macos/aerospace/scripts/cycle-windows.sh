#!/usr/bin/env bash
# Cycle focus through every window in the current aerospace workspace,
# including floating windows. Order is stable (sorted by window-id).
#
# Usage: cycle-windows.sh next | prev
#
# Bound to alt-tab / alt-shift-tab in aerospace.toml. Replaces alt-tab-macos,
# which can't scope to aerospace workspaces (see commit 3f85).

set -euo pipefail

AEROSPACE=/usr/local/bin/aerospace
dir="${1:-next}"

# All windows in the focused workspace, sorted numerically for stable cycling.
# Avoid `mapfile` — macOS's system bash is 3.2 and doesn't have it.
ids=()
while IFS= read -r id; do
    ids+=("$id")
done < <("$AEROSPACE" list-windows --workspace focused --format '%{window-id}' | sort -n)

count=${#ids[@]}
(( count < 2 )) && exit 0

# Currently focused window id (empty if no focus, e.g. just after workspace switch).
focused=$("$AEROSPACE" list-windows --focused --format '%{window-id}' 2>/dev/null || true)

idx=-1
for i in "${!ids[@]}"; do
    if [[ "${ids[$i]}" == "$focused" ]]; then
        idx=$i
        break
    fi
done

# Not in the list (e.g. focus on something outside the workspace) → start at 0
# when going next, wrap to last when going prev.
if (( idx < 0 )); then
    new_idx=$(( dir == "prev" ? count - 1 : 0 ))
elif [[ "$dir" == "prev" ]]; then
    new_idx=$(( (idx - 1 + count) % count ))
else
    new_idx=$(( (idx + 1) % count ))
fi

"$AEROSPACE" focus --window-id "${ids[$new_idx]}"
