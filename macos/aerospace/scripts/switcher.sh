#!/usr/bin/env bash
# Workspace-scoped MRU window switcher. Driven by Karabiner; renders a
# sketchybar popup. See docs/superpowers/specs/2026-07-24-aerospace-window-switcher-design.md
# Target: macOS system bash 3.2 (no mapfile / associative arrays).
set -uo pipefail

AEROSPACE="${AEROSPACE_BIN:-/opt/homebrew/bin/aerospace}"
SKETCHYBAR="${SKETCHYBAR_BIN:-/usr/local/bin/sketchybar}"
MRU_FILE="${MRU_FILE:-$HOME/.cache/aerospace/mru}"
STATE_FILE="${STATE_FILE:-/tmp/aerospace-switcher.state}"
ICON_MAP="${ICON_MAP:-$HOME/.config/sketchybar/plugins/icon_map.sh}"

# Reorder live `id|app|title` lines (stdin) MRU-first. $1 = mru file.
build_order() {
  local mru="$1"
  local live; live="$(cat)"
  local recency=""
  [ -f "$mru" ] && recency="$(tail -r "$mru" 2>/dev/null | awk 'NF && !seen[$0]++')"
  local emitted=" "
  local id line
  while IFS= read -r id; do
    [ -z "$id" ] && continue
    line="$(printf '%s\n' "$live" | awk -F'|' -v id="$id" '$1==id{print; exit}')"
    if [ -n "$line" ]; then
      printf '%s\n' "$line"
      emitted="$emitted$id "
    fi
  done <<EOF
$recency
EOF
  # Live windows never focused (absent from history), in input order.
  printf '%s\n' "$live" | while IFS='|' read -r id app title; do
    [ -z "$id" ] && continue
    case "$emitted" in *" $id "*) ;; *) printf '%s|%s|%s\n' "$id" "$app" "$title" ;; esac
  done
}

open_switcher() { # $1 = "--last" to start on the furthest-MRU window
  local live ordered count sel=1
  live="$("$AEROSPACE" list-windows --workspace focused \
          --format '%{window-id}|%{app-name}|%{window-title}')"
  ordered="$(printf '%s\n' "$live" | build_order "$MRU_FILE")"
  count="$(printf '%s\n' "$ordered" | awk 'NF' | wc -l | tr -d ' ')"
  if [ "$count" -lt 2 ]; then
    rm -f "$STATE_FILE"
    return 0
  fi
  [ "${1:-}" = "--last" ] && sel=$((count - 1))
  { echo "$sel"; printf '%s\n' "$ordered" | awk 'NF'; } > "$STATE_FILE"
  render
}

# Real render lands in Task 3; stub keeps `open` working under test.
render() { :; }

case "${1:-}" in
  open) open_switcher "${2:-}" ;;
  *)    echo "usage: switcher.sh open|next|prev|commit|cancel" >&2; exit 2 ;;
esac
