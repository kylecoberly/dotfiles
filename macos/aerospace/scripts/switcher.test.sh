#!/usr/bin/env bash
# Plain-bash tests for switcher.sh. No framework. Exits 1 on first failure.
set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT="$DIR/switcher.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Stub aerospace: `list-windows --workspace focused --format ...` prints canned
# lines; `focus --window-id N` records N to $TMP/focused.
cat > "$TMP/aerospace" <<'STUB'
#!/usr/bin/env bash
case "$1 $2" in
  "list-windows --workspace") cat "$AEROSPACE_FIXTURE" ;;
  "focus --window-id")        echo "$3" > "$AEROSPACE_FOCUSED_OUT" ;;
esac
STUB
chmod +x "$TMP/aerospace"

# Common env for invoking switcher.sh under test.
run() {
  AEROSPACE_BIN="$TMP/aerospace" \
  SKETCHYBAR_BIN="/usr/bin/true" \
  MRU_FILE="$TMP/mru" \
  STATE_FILE="$TMP/state" \
  ICON_MAP="/dev/null" \
  AEROSPACE_FIXTURE="$TMP/live" \
  AEROSPACE_FOCUSED_OUT="$TMP/focused" \
  bash "$SCRIPT" "$@"
}

fail() { echo "FAIL: $1"; exit 1; }

# --- open orders MRU-first, selection starts at previous window (index 1) ---
printf '10|Alacritty|nvim\n20|Zen|GitHub\n30|Obsidian|notes\n' > "$TMP/live"
# history: 30 focused earlier, then 20, then 10 (10 most recent)
printf '30\n20\n10\n' > "$TMP/mru"
run open
[ -f "$TMP/state" ] || fail "open wrote no state"
idx="$(sed -n '1p' "$TMP/state")"
[ "$idx" = "1" ] || fail "expected index 1, got $idx"
# recency (most recent first) = 10,20,30 -> display order
[ "$(sed -n '2p' "$TMP/state")" = "10|Alacritty|nvim" ] || fail "row1 wrong: $(sed -n '2p' "$TMP/state")"
[ "$(sed -n '3p' "$TMP/state")" = "20|Zen|GitHub" ]     || fail "row2 wrong"
[ "$(sed -n '4p' "$TMP/state")" = "30|Obsidian|notes" ] || fail "row3 wrong"

# --- live window absent from history sorts to the tail ---
printf '10|Alacritty|nvim\n99|Finder|Downloads\n' > "$TMP/live"
printf '10\n' > "$TMP/mru"
run open
[ "$(sed -n '2p' "$TMP/state")" = "10|Alacritty|nvim" ]   || fail "mru row not first"
[ "$(sed -n '3p' "$TMP/state")" = "99|Finder|Downloads" ] || fail "unseen row not tail"

# --- open --last selects the final row ---
printf '10|Alacritty|nvim\n20|Zen|GitHub\n30|Obsidian|notes\n' > "$TMP/live"
printf '30\n20\n10\n' > "$TMP/mru"          # recency 10,20,30
run open --last
[ "$(sed -n '1p' "$TMP/state")" = "2" ] || fail "open --last did not select last row (2)"

# --- fewer than 2 windows: no state written ---
printf '10|Alacritty|nvim\n' > "$TMP/live"
rm -f "$TMP/state"
run open
[ ! -f "$TMP/state" ] || fail "open wrote state for single window"

echo "Task 1 tests passed"
