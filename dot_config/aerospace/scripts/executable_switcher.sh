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

_count() { awk 'NR>1 && NF' "$STATE_FILE" | wc -l | tr -d ' '; }

_move() { # $1 = +1 or -1
  [ -f "$STATE_FILE" ] || return 0
  local idx count
  idx="$(sed -n '1p' "$STATE_FILE")"
  count="$(_count)"
  [ "$count" -lt 1 ] && return 0
  idx=$(( (idx + $1 + count) % count ))
  # rewrite line 1 with new index, keep rows
  { echo "$idx"; awk 'NR>1' "$STATE_FILE"; } > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
  render
}

commit_switcher() {
  [ -f "$STATE_FILE" ] || return 0
  local idx id
  idx="$(sed -n '1p' "$STATE_FILE")"
  # row for idx: file line number is idx+2 (line1=index, rows start line2)
  id="$(sed -n "$((idx + 2))p" "$STATE_FILE" | cut -d'|' -f1)"
  teardown
  rm -f "$STATE_FILE"
  [ -n "$id" ] && "$AEROSPACE" focus --window-id "$id"
}

cancel_switcher() {
  teardown
  rm -f "$STATE_FILE"
}

# --- rendering (sketchybar popup) --------------------------------------------
# Under test, SKETCHYBAR_BIN=/usr/bin/true makes all these calls no-ops.

_load_palette() {
  [ -n "${_PAL_LOADED:-}" ] && return 0
  # shellcheck disable=SC1090
  . "$HOME/dotfiles/theme/palette.sh" 2>/dev/null || return 0
  ACTIVE="0xb3${blue#\#}"; FG="0xff${fg#\#}"; FG_DIM="0xff${comment#\#}"
  _PAL_LOADED=1
}

_glyph() { # $1 = app name -> stdout glyph (via icon_map)
  icon_result=""
  # shellcheck disable=SC1090
  [ -f "$ICON_MAP" ] && . "$ICON_MAP" && __icon_map "$1"
  printf '%s' "$icon_result"
}

_clear_children() {
  local children it
  children="$("$SKETCHYBAR" --query switcher 2>/dev/null \
    | awk -F'"' '/switcher\.win\.|switcher\.title/{print $2}')"
  for it in $children; do "$SKETCHYBAR" --remove "$it" >/dev/null 2>&1 || true; done
}

teardown() {
  # Called on commit/cancel: drop children, hide popup, restore the center text.
  _clear_children
  "$SKETCHYBAR" --set switcher popup.drawing=off >/dev/null 2>&1 || true
  "$SKETCHYBAR" --set focused_windows drawing=on >/dev/null 2>&1 || true
  # Force a repaint — toggling drawing alone can leave a stale frame.
  "$SKETCHYBAR" --update >/dev/null 2>&1 || true
}

render() {
  [ -f "$STATE_FILE" ] || return 0
  _load_palette
  _clear_children
  # Hide the center app-list while switching so the anchor is the sole center
  # item (true center) and doesn't overlap the popup.
  "$SKETCHYBAR" --set focused_windows drawing=off >/dev/null 2>&1 || true
  local idx; idx="$(sed -n '1p' "$STATE_FILE")"
  local n=0 id app title glyph icon_color bg lbl
  while IFS='|' read -r id app title; do
    [ -z "$id" ] && continue
    glyph="$(_glyph "$app")"
    if [ "$n" = "$idx" ]; then
      icon_color="$FG"; bg="$ACTIVE"; lbl="$title"
    else
      icon_color="$FG_DIM"; bg=0x00000000; lbl=""
    fi
    "$SKETCHYBAR" --add item "switcher.win.$n" popup.switcher >/dev/null \
      --set "switcher.win.$n" \
            icon="$glyph" icon.font="sketchybar-app-font:Regular:22.0" \
            icon.color="$icon_color" icon.padding_left=10 icon.padding_right=8 \
            label="$lbl" label.color="$FG" label.padding_right=10 \
            background.color="$bg" background.corner_radius=8 background.height=34 \
            >/dev/null
    n=$((n + 1))
  done < <(awk 'NR>1' "$STATE_FILE")
  "$SKETCHYBAR" --set switcher popup.drawing=on >/dev/null
  # Force a repaint — hiding focused_windows can otherwise leave a stale frame.
  "$SKETCHYBAR" --update >/dev/null 2>&1 || true
}

case "${1:-}" in
  open)   open_switcher "${2:-}" ;;
  next)   _move 1 ;;
  prev)   _move -1 ;;
  commit) commit_switcher ;;
  cancel) cancel_switcher ;;
  *)      echo "usage: switcher.sh open|next|prev|commit|cancel" >&2; exit 2 ;;
esac
