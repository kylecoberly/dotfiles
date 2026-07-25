# Workspace-scoped MRU Window Switcher Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Give `alt-tab` a native-style icon popup — a window switcher scoped to the current AeroSpace workspace, MRU-ordered, hold-to-preview / release-to-commit.

**Architecture:** A bash helper (`switcher.sh`) owns all logic and state and drives a top-center sketchybar popup; a Karabiner state machine drives the helper from key events (commit on Option-release); an AeroSpace `on-focus-changed` callback records focus history for MRU ordering.

**Tech Stack:** bash 3.2 (macOS system bash), AeroSpace CLI (socket), sketchybar CLI, Karabiner-Elements complex modifications, sketchybar-app-font.

## Global Constraints

Every task's requirements implicitly include these:

- **Target bash 3.2.57** (macOS system bash). No `mapfile`/`readarray`, no associative arrays, no `${var^^}`. `tail -r` for reverse (BSD, confirmed present).
- **Full binary paths in Karabiner `shell_command` and AeroSpace callbacks.** Both run with the bare launchd PATH (`/usr/bin:/bin:/usr/sbin:/sbin`); bare `sketchybar`/`aerospace` are not found. Use `/usr/local/bin/sketchybar` and `/opt/homebrew/bin/aerospace`.
- **`switcher.sh` takes all external dependencies via env-var overrides** (defaults are the real paths) so it is testable without the GUI: `AEROSPACE_BIN`, `SKETCHYBAR_BIN`, `MRU_FILE`, `STATE_FILE`, `ICON_MAP`.
- **karabiner.json edits go through `macos/karabiner/sync.sh`** (which enforces the device-state drift guard) — edit the dotfiles copy, then run sync.sh. Never hand-edit only the live copy.
- **Palette:** Tokyo Night via `$HOME/dotfiles/theme/palette.sh`. Active = `0xb3${blue}`, surface = `0x99${bg_highlight}`, fg = `0xff${fg}`, dim = `0xff${comment}` — matching the existing workspace pills.
- **No test framework** (bats absent). Tests are plain-bash scripts that `exit 1` on failure.

## File Structure

- **Create** `macos/aerospace/scripts/switcher.sh` — helper: subcommands `open|next|prev|commit|cancel`, MRU ordering, snapshot state, and the sketchybar render calls. One responsibility: switcher state + rendering.
- **Create** `macos/aerospace/scripts/switcher.test.sh` — plain-bash unit tests for the pure logic (ordering, index math, commit target) using a stub `aerospace` and no-op `sketchybar`.
- **Modify** `macos/aerospace/aerospace.toml` — add `on-focus-changed` (MRU tracker); remove `alt-tab`/`alt-shift-tab` bindings.
- **Modify** `macos/sketchybar/sketchybarrc` — add the center-anchored `switcher` popup item.
- **Modify** `macos/karabiner/karabiner.json` — the alt-tab state machine (synced via sync.sh).
- **Delete** `macos/aerospace/scripts/cycle-windows.sh` — subsumed.

---

### Task 1: `switcher.sh` — MRU ordering + `open` (snapshot state)

Builds the testable core: given the focused workspace's live windows and the MRU history, produce the ordered window list and write the snapshot with the selection pre-set to the previous window. `render` is a stub no-op in this task (real render in Task 3).

**Files:**
- Create: `macos/aerospace/scripts/switcher.sh`
- Test: `macos/aerospace/scripts/switcher.test.sh`

**Interfaces:**
- Produces: `switcher.sh open [--last]` → writes `$STATE_FILE`: line 1 = selected index (0-based; `open` starts at `1` = previous window, `open --last` starts at `count-1` = furthest MRU), lines 2.. = `window-id|app-name|window-title` in display order. Writes nothing and exits 0 if `<2` windows.
- Produces (internal, tested): `build_order` reads live `id|app|title` lines on stdin, arg `$1` = mru file path, prints lines reordered MRU-first (recency by last occurrence in mru file), live windows absent from history appended in input order.
- Env: `AEROSPACE_BIN` (default `/opt/homebrew/bin/aerospace`), `SKETCHYBAR_BIN` (default `/usr/local/bin/sketchybar`), `MRU_FILE` (default `$HOME/.cache/aerospace/mru`), `STATE_FILE` (default `/tmp/aerospace-switcher.state`), `ICON_MAP` (default `$HOME/.config/sketchybar/plugins/icon_map.sh`).

- [ ] **Step 1: Write the failing test**

Create `macos/aerospace/scripts/switcher.test.sh`:

```bash
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash macos/aerospace/scripts/switcher.test.sh`
Expected: FAIL — `switcher.sh` does not exist yet (`No such file`).

- [ ] **Step 3: Write minimal implementation**

Create `macos/aerospace/scripts/switcher.sh`:

```bash
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
```

- [ ] **Step 4: Run test to verify it passes**

Run: `bash macos/aerospace/scripts/switcher.test.sh`
Expected: PASS — prints `Task 1 tests passed`.

- [ ] **Step 5: Commit**

```bash
chmod +x macos/aerospace/scripts/switcher.sh macos/aerospace/scripts/switcher.test.sh
git add macos/aerospace/scripts/switcher.sh macos/aerospace/scripts/switcher.test.sh
git commit -m "feat(switcher): MRU ordering + open snapshot with tests"
```

---

### Task 2: `switcher.sh` — `next` / `prev` / `commit` / `cancel`

Selection movement (wrap-around) and the terminal actions.

**Files:**
- Modify: `macos/aerospace/scripts/switcher.sh`
- Test: `macos/aerospace/scripts/switcher.test.sh`

**Interfaces:**
- Produces: `next`/`prev` mutate line 1 (index) of `$STATE_FILE` with wrap-around over the row count, then `render`. No-op if no state file.
- Produces: `commit` reads the selected row, runs `"$AEROSPACE" focus --window-id <id>`, tears down (calls `teardown`, removes `$STATE_FILE`). No-op if no state file.
- Produces: `cancel` tears down without focusing.
- Produces (internal): `teardown` hides the popup (real body in Task 3; stub `:` here).

- [ ] **Step 1: Write the failing test**

Append to `macos/aerospace/scripts/switcher.test.sh` before the final `echo`:

```bash
# --- next advances index, wraps around ---
printf '10|Alacritty|nvim\n20|Zen|GitHub\n30|Obsidian|notes\n' > "$TMP/live"
printf '30\n20\n10\n' > "$TMP/mru"   # recency 10,20,30
run open                              # index 1 (row 20)
run next                              # index 2 (row 30)
[ "$(sed -n '1p' "$TMP/state")" = "2" ] || fail "next did not advance to 2"
run next                              # wrap to 0
[ "$(sed -n '1p' "$TMP/state")" = "0" ] || fail "next did not wrap to 0"

# --- prev goes backward, wraps ---
run prev                              # 0 -> 2
[ "$(sed -n '1p' "$TMP/state")" = "2" ] || fail "prev did not wrap to 2"

# --- commit focuses the selected window and clears state ---
run open                              # index 1 -> row is 20|Zen|GitHub
run commit
[ "$(cat "$TMP/focused")" = "20" ] || fail "commit focused $(cat "$TMP/focused"), want 20"
[ ! -f "$TMP/state" ] || fail "commit left state behind"

# --- cancel clears state without focusing ---
: > "$TMP/focused"
run open
run cancel
[ ! -f "$TMP/state" ] || fail "cancel left state behind"
[ ! -s "$TMP/focused" ] || fail "cancel changed focus"

# --- next/commit with no state are harmless no-ops ---
rm -f "$TMP/state"; : > "$TMP/focused"
run next
run commit
[ ! -s "$TMP/focused" ] || fail "commit without state changed focus"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash macos/aerospace/scripts/switcher.test.sh`
Expected: FAIL — `next`/`commit`/`cancel` hit the `usage` branch (exit 2), assertions fail.

- [ ] **Step 3: Write minimal implementation**

In `switcher.sh`, add these functions above the `case`:

```bash
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

teardown() { :; }   # real body in Task 3
```

And extend the `case`:

```bash
case "${1:-}" in
  open)   open_switcher "${2:-}" ;;
  next)   _move 1 ;;
  prev)   _move -1 ;;
  commit) commit_switcher ;;
  cancel) cancel_switcher ;;
  *)      echo "usage: switcher.sh open|next|prev|commit|cancel" >&2; exit 2 ;;
esac
```

- [ ] **Step 4: Run test to verify it passes**

Run: `bash macos/aerospace/scripts/switcher.test.sh`
Expected: PASS — prints `Task 1 tests passed` and reaches the end without a FAIL.

- [ ] **Step 5: Commit**

```bash
git add macos/aerospace/scripts/switcher.sh macos/aerospace/scripts/switcher.test.sh
git commit -m "feat(switcher): next/prev/commit/cancel with wrap-around"
```

---

### Task 3: sketchybar popup — anchor item + real `render`/`teardown`

Adds the invisible center anchor and makes `switcher.sh` draw the popup: a row of one app glyph per window with the selected one highlighted, plus the selected window's title label.

**Files:**
- Modify: `macos/sketchybar/sketchybarrc`
- Modify: `macos/aerospace/scripts/switcher.sh`

**Interfaces:**
- Consumes: sketchybar item `switcher` (center, `drawing=off`, `popup.drawing=off`) defined in sketchybarrc; palette in `theme/palette.sh`; `__icon_map` from `$ICON_MAP` (sets `$icon_result` from an app name).
- Produces: `render` rebuilds `switcher` popup children `switcher.win.<n>` (glyphs) + `switcher.title` (label) and sets `switcher.popup.drawing=on`; `teardown` removes children and sets `drawing=off`.

- [ ] **Step 1: Add the anchor item to `sketchybarrc`**

After the `focused_windows` block (around line 91), before the RIGHT items:

```bash
# ─── Window switcher popup (driven by switcher.sh) ─────────────
# Invisible anchor in the bar center; switcher.sh fills the popup on alt-tab.
sketchybar --add item switcher center \
           --set switcher \
                    drawing=off \
                    icon.drawing=off \
                    label.drawing=off \
                    popup.drawing=off \
                    popup.align=center \
                    popup.background.color=$BG \
                    popup.background.corner_radius=14 \
                    popup.background.border_width=1 \
                    popup.background.border_color=$BORDER
```

- [ ] **Step 2: Reload and verify the anchor exists (no visual change yet)**

Run: `/usr/local/bin/sketchybar --reload && sleep 1 && /usr/local/bin/sketchybar --query switcher | grep -m1 '"name"'`
Expected: prints `"name": "switcher"`; the bar looks unchanged (item is `drawing=off`).

- [ ] **Step 3: Implement real `render` and `teardown` in `switcher.sh`**

Replace the `render() { :; }` stub and `teardown() { :; }` stub with:

```bash
# Palette (sourced lazily; harmless under test where render isn't asserted).
_load_palette() {
  [ -n "${_PAL_LOADED:-}" ] && return 0
  # shellcheck disable=SC1090
  . "$HOME/dotfiles/theme/palette.sh" 2>/dev/null || return 0
  ACTIVE="0xb3${blue#\#}"; SURFACE="0x99${bg_highlight#\#}"
  FG="0xff${fg#\#}"; FG_DIM="0xff${comment#\#}"
  _PAL_LOADED=1
}

_glyph() { # $1 = app name -> stdout glyph (via icon_map)
  icon_result=""
  # shellcheck disable=SC1090
  [ -f "$ICON_MAP" ] && . "$ICON_MAP" && __icon_map "$1"
  printf '%s' "$icon_result"
}

teardown() {
  # Remove any existing children, hide popup.
  local existing
  existing="$("$SKETCHYBAR" --query bar >/dev/null 2>&1; "$SKETCHYBAR" --query switcher 2>/dev/null | awk -F'"' '/switcher\.(win|title)/{print $2}')"
  "$SKETCHYBAR" --set switcher popup.drawing=off >/dev/null 2>&1 || true
  local it
  for it in $existing; do "$SKETCHYBAR" --remove "$it" >/dev/null 2>&1 || true; done
}

render() {
  [ -f "$STATE_FILE" ] || return 0
  _load_palette
  teardown
  local idx; idx="$(sed -n '1p' "$STATE_FILE")"
  local n=0 id app title glyph bg fgc sel_title=""
  # rows start at file line 2
  while IFS='|' read -r id app title; do
    [ -z "$id" ] && continue
    glyph="$(_glyph "$app")"
    if [ "$n" = "$idx" ]; then bg="$ACTIVE"; fgc="$FG"; sel_title="$app — $title";
    else bg=0x00000000; fgc="$FG_DIM"; fi
    "$SKETCHYBAR" --add item "switcher.win.$n" popup.switcher >/dev/null \
      --set "switcher.win.$n" \
            label="$glyph" label.font="sketchybar-app-font:Regular:22.0" \
            label.color="$fgc" \
            background.color="$bg" background.corner_radius=8 background.height=34 \
            icon.drawing=off >/dev/null
    n=$((n + 1))
  done < <(awk 'NR>1' "$STATE_FILE")
  "$SKETCHYBAR" --add item switcher.title popup.switcher >/dev/null \
    --set switcher.title label="$sel_title" label.color="$FG" \
          icon.drawing=off background.drawing=off >/dev/null
  "$SKETCHYBAR" --set switcher popup.drawing=on >/dev/null
}
```

- [ ] **Step 4: Manual visual verification**

With at least 2 windows on the focused workspace, run:
`/opt/homebrew/bin/aerospace workspace 2 && macos/aerospace/scripts/switcher.sh open`
Expected: a centered popup drops from the bar showing one app glyph per window on workspace 2, the second (previous) highlighted, with its `App — title` label below.
Then: `macos/aerospace/scripts/switcher.sh next` (highlight advances) and `macos/aerospace/scripts/switcher.sh cancel` (popup disappears).

- [ ] **Step 5: Re-run the unit tests (render must not break them)**

Run: `bash macos/aerospace/scripts/switcher.test.sh`
Expected: PASS (tests use `SKETCHYBAR_BIN=/usr/bin/true`, so render calls are no-ops).

- [ ] **Step 6: Commit**

```bash
git add macos/sketchybar/sketchybarrc macos/aerospace/scripts/switcher.sh
git commit -m "feat(switcher): sketchybar popup render + teardown"
```

---

### Task 4: MRU tracker — AeroSpace `on-focus-changed`

Records focus history so `open` can order by recency.

**Files:**
- Modify: `macos/aerospace/aerospace.toml`

**Interfaces:**
- Produces: `~/.cache/aerospace/mru` — appends the focused window-id on each focus change (skips when no window is focused).

- [ ] **Step 1: Add the callback**

In `aerospace.toml`, after the `exec-on-workspace-change` block, add:

```toml
# MRU tracker for the window switcher: append the focused window-id to a
# history file on every focus change. Full path — AeroSpace's callback PATH is
# the bare launchd set. `mkdir -p` is cheap and makes first run self-healing.
on-focus-changed = ['/bin/bash', '-c',
    'mkdir -p "$HOME/.cache/aerospace"; id=$(/opt/homebrew/bin/aerospace list-windows --focused --format "%{window-id}" 2>/dev/null); [ -n "$id" ] && echo "$id" >> "$HOME/.cache/aerospace/mru"']
```

- [ ] **Step 2: Reload and verify recording**

Run:
```bash
/opt/homebrew/bin/aerospace reload-config
rm -f ~/.cache/aerospace/mru
/opt/homebrew/bin/aerospace workspace 1; sleep 0.4
/opt/homebrew/bin/aerospace workspace 2; sleep 0.4
cat ~/.cache/aerospace/mru
```
Expected: the file exists and contains window-ids (one per focus change), most-recent last. If a workspace was empty, no line was added for it.

- [ ] **Step 3: Verify `open` now orders by real recency**

Focus two windows in a known order, then `switcher.sh open` and inspect `/tmp/aerospace-switcher.state` — the most-recently-focused window is row 1, the previous is row 2 (and pre-selected).

- [ ] **Step 4: Commit**

```bash
git add macos/aerospace/aerospace.toml
git commit -m "feat(switcher): on-focus-changed MRU tracker"
```

---

### Task 5: Karabiner state machine (the alt-tab trigger)

Routes Option+Tab through Karabiner so commit can fire on Option-release. **This is the flagged-risk task** — verify release-detection works; if not, apply the idle-timeout fallback (Step 6).

**Files:**
- Modify: `macos/karabiner/karabiner.json` (dotfiles copy), then `macos/karabiner/sync.sh` to push.

**Interfaces:**
- Consumes: `switcher.sh open|next|prev|commit|cancel` at `/Users/kylecoberly/dotfiles/macos/aerospace/scripts/switcher.sh`.
- Produces: a complex-modification rule using variable `alt_tab_active`.

- [ ] **Step 1: Add the rule to the dotfiles karabiner.json**

Insert as a new rule in `profiles[0].complex_modifications.rules` (a script is fine, given the file size). The rule's manipulators — `SW` is `/Users/kylecoberly/dotfiles/macos/aerospace/scripts/switcher.sh`:

Manipulators are order-sensitive; list the `shift` variants **before** the
non-shift ones. Non-shift manipulators use `mandatory: [left_option]` with **no**
`optional` (so Shift+Tab does not match them); shift manipulators use
`mandatory: [left_option, left_shift]`. These are disjoint, so no idempotency
guard is needed — `open`/`open --last` fire only on the `alt_tab_active` 0→1
transition.

1. **Reverse-open** — from `tab` + mandatory `left_option,left_shift`, condition `alt_tab_active` is 0 → set `alt_tab_active=1`; `shell_command: "$SW open --last"`.
2. **Reverse-advance** — from `tab` + mandatory `left_option,left_shift`, condition `alt_tab_active` is 1 → `shell_command: "$SW prev"`.
3. **Open** — from `tab` + mandatory `left_option`, condition `alt_tab_active` is 0 → set `alt_tab_active=1`; `shell_command: "$SW open"`.
4. **Advance** — from `tab` + mandatory `left_option`, condition `alt_tab_active` is 1 → `shell_command: "$SW next"`.
5. **Cancel** — from `escape`, condition `alt_tab_active` is 1 → set `alt_tab_active=0`; `shell_command: "$SW cancel"`.
6. **Commit on release** — from `left_option` with `modifiers.optional: [any]`, condition `alt_tab_active` is 1 → `to: [{key_code: left_option}]`, `to_after_key_up: [{set alt_tab_active=0}, {shell_command: "$SW commit"}]`.

- [ ] **Step 2: Sync to the live config**

Run: `macos/karabiner/sync.sh`
Expected: copies dotfiles→live (drift guard passes since device state is already reconciled); Karabiner auto-reloads.

- [ ] **Step 3: Verify the config parses**

Run: `"/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli" --select-profile 'Default profile'; echo $?`
Expected: `0`.

- [ ] **Step 4: Manual behavior test**

On a workspace with ≥2 windows:
- Hold physical left-Cmd, tap Tab → popup appears, previous window pre-selected.
- Keep holding, tap Tab → selection advances; `Shift+Tab` → reverses.
- Release → focus commits to the selected window; popup closes.
- Quick tap-and-release → jumps to previous window (MRU).
- `Escape` while open → closes without switching.
- On an empty / single-window workspace → nothing appears; release is harmless.

- [ ] **Step 5: If release-commit works, commit the change**

```bash
git add macos/karabiner/karabiner.json
git commit -m "feat(switcher): karabiner alt-tab state machine, commit on option-release"
```

- [ ] **Step 6: FALLBACK — only if Step 4 shows release-commit is unreliable**

Replace manipulator 5 with commit-on-idle: in `open`/`next`/`prev`, after `render`, schedule commit via a debounced background timer (write a token to `$STATE_FILE.tick`; a `sleep 0.2` guard commits if no newer tick). Document the deviation in the commit message and in the spec's Non-goals/Notes. Re-run Step 4 (all bullets except the "release" ones; commit now fires ~200ms after the last Tap).

---

### Task 6: Cutover + cleanup

Remove the old cycler and its AeroSpace bindings; final integration check.

**Files:**
- Modify: `macos/aerospace/aerospace.toml` (remove `alt-tab`/`alt-shift-tab`)
- Delete: `macos/aerospace/scripts/cycle-windows.sh`

**Interfaces:** none produced; this finalizes the cutover.

- [ ] **Step 1: Remove the old AeroSpace bindings**

In `aerospace.toml` `[mode.main.binding]`, delete the two lines:

```toml
    alt-tab       = 'exec-and-forget ~/dotfiles/macos/aerospace/scripts/cycle-windows.sh next'
    alt-shift-tab = 'exec-and-forget ~/dotfiles/macos/aerospace/scripts/cycle-windows.sh prev'
```

(and their comment block above them). Leave all other bindings intact.

- [ ] **Step 2: Reload and confirm no double-handling**

Run: `/opt/homebrew/bin/aerospace reload-config && echo ok`
Expected: `ok`. Now Option+Tab is handled only by Karabiner. Test once more that alt-tab opens the popup (not the old instant cycle).

- [ ] **Step 3: Delete the retired script**

```bash
git rm macos/aerospace/scripts/cycle-windows.sh
```

- [ ] **Step 4: Full integration pass**

- alt-tab popup opens, cycles, commits on release (or idle, if fallback).
- Scope: put windows on WS1 and WS2; on WS2 the popup lists only WS2 windows.
- Bar highlight still tracks workspace switches (regression check on Task 3's sketchybarrc edit).
- `bash macos/aerospace/scripts/switcher.test.sh` still passes.

- [ ] **Step 5: Commit**

```bash
git add macos/aerospace/aerospace.toml
git commit -m "refactor(switcher): retire cycle-windows.sh, move alt-tab to karabiner"
```

---

## Self-Review

**Spec coverage:**
- Behavior (hold-preview, MRU, previous-preselected, Shift reverse, Escape, ≤1 no-op) → Tasks 1,2,5. ✓
- Component 1 MRU tracker → Task 4. ✓
- Component 2 Karabiner state machine → Task 5. ✓
- Component 3 helper (open/next/prev/commit/cancel, ordering, snapshot) → Tasks 1,2. ✓
- Component 4 sketchybar popup → Task 3. ✓
- Data flow / state files → Tasks 1,3,4. ✓
- Edge cases (empty, single, dead ids, missing history) → Task 1 (`<2` no-op, `build_order` intersect), Task 2 (`commit` no-op), Task 4 (skip empty). ✓
- Files-touched list, retire cycle-windows.sh → Task 6. ✓
- Implementation risk + fallback → Task 5 Steps 4/6. ✓

**Placeholder scan:** No TBD/TODO; every code step has real code; manual-verification steps (GUI/Karabiner) state exact commands and expected outcomes.

**Type/name consistency:** `AEROSPACE_BIN/SKETCHYBAR_BIN/MRU_FILE/STATE_FILE/ICON_MAP`, `build_order`, `open_switcher`, `render`, `teardown`, `_move`, `commit_switcher`, `cancel_switcher`, state format (line1 index, rows `id|app|title`, row line = idx+2), variable `alt_tab_active`, popup children `switcher.win.<n>`/`switcher.title` — used consistently across tasks. ✓
