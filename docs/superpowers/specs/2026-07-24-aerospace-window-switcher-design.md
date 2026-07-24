# Workspace-scoped MRU window switcher

**Date:** 2026-07-24
**Status:** Design approved, pending spec review

## Goal

Give `alt-tab` a native-macOS-style visual switcher — a popup of app icons with
a moving selection — **scoped to the current AeroSpace workspace**. AltTab and
native Cmd-Tab were both rejected because neither can scope to an AeroSpace
workspace (AeroSpace parks inactive-workspace windows off-screen on one macOS
Space, so external switchers see every window at once).

Icons only; no live window thumbnails (native Cmd-Tab is also icons-only).

## Behavior (the felt experience)

- **Physical left-Cmd (= Option, via the Karabiner swap) + Tab** opens a popup
  dropping from bar-center, showing **one glyph per window in the current
  workspace**, ordered most-recently-used, with the **previous** window
  pre-selected (MRU index 1).
- **Release Option → focus commits** to the selected window. A quick
  Cmd-Tap-release therefore flicks to your last window, like native.
- **Hold Option, tap Tab again → selection advances** down the MRU list.
  **Option+Shift+Tab → backwards.** **Escape → close without switching.**
- The selected glyph is highlighted; the selected window's **title** shows as a
  label beneath the row, so two windows of the same app (e.g. two Alacritty)
  are distinguishable.
- **≤1 window** in the workspace → no popup drawn; release is a harmless no-op.

Scope is always the **focused** workspace's live windows. This replaces the
current instant, no-visual cycler (`cycle-windows.sh`).

## Architecture — four components

### 1. MRU tracker (aerospace.toml `on-focus-changed`)
A new `on-focus-changed` callback appends the focused window-id to a history
file. Runs on every focus change; must be cheap and use a **full binary path**
(AeroSpace's callback PATH is the bare launchd set — the same gotcha that broke
the sketchybar trigger).

- File: `~/.cache/aerospace/mru` (one window-id per line, most-recent appended
  last). Created on first focus change.
- Callback: query `/opt/homebrew/bin/aerospace list-windows --focused
  --format '%{window-id}'`; if non-empty, append. Empty (empty workspace) → skip.
- No pruning on write (append-only, cheap). The read side prunes.

### 2. Karabiner state machine (karabiner.json)
Owns a mode variable `alt_tab_active`. All shell calls use full paths
(`/usr/local/bin`, `/opt/homebrew/bin`, script absolute path) because Karabiner
`shell_command` runs with a minimal environment.

- `Option+Tab`, `alt_tab_active == 0` → set `alt_tab_active = 1`; run
  `switcher.sh open`.
- `Option+Tab`, `alt_tab_active == 1` → run `switcher.sh next`.
- `Option+Shift+Tab` → run `switcher.sh prev` (and open if not active).
- `Escape`, `alt_tab_active == 1` → set `alt_tab_active = 0`; run
  `switcher.sh cancel`.
- **Option key-release**, `alt_tab_active == 1` → set `alt_tab_active = 0`; run
  `switcher.sh commit`.

The matched key is `left_option` (physical left-Cmd, after the Cmd↔Opt
simple-modification swap, which is applied before complex modifications).

**Implementation risk (flagged):** reliably firing an action on *modifier
release* while the modifier was already held before the mode began is the
fiddliest part of Karabiner. The intended mechanism is a manipulator matching
`left_option` with `to_after_key_up`, armed by the mode condition. Public
Cmd-Tab-replacement configs do this; the implementation plan must build and
**test** it. If release-detection proves unreliable, the fallback is
commit-on-short-idle-timeout (~200 ms after the last Tab) — a degraded but
functional variant. Release-commit is the primary target.

### 3. Helper script (`macos/aerospace/scripts/switcher.sh`)
Subcommands `open | next | prev | commit | cancel`. Holds no long-running
state; reads/writes a snapshot file.

- **open:**
  1. List focused workspace windows:
     `aerospace list-windows --workspace focused --format
     '%{window-id}|%{app-name}|%{window-title}'`.
  2. Build MRU order: read `~/.cache/aerospace/mru`, reverse, de-dup keeping
     first occurrence → recency order; intersect with live window-ids; append
     any live window absent from history in window-id order (stable tail).
  3. If `<2` windows: do nothing (no snapshot, no popup).
  4. Write snapshot to `/tmp/aerospace-switcher.state`: line 1 = selected index
     (starts at `1`), following lines = `window-id|app-name|window-title` in
     display order.
  5. Render the popup (component 4), highlighting index 1.
- **next / prev:** adjust the index (wrap-around) in the snapshot, re-render.
- **commit:** read snapshot; `aerospace focus --window-id <selected>`; tear down
  popup; delete snapshot. No snapshot / <2 windows → no-op.
- **cancel:** tear down popup; delete snapshot. No focus change.

Reuses the existing `~/.config/sketchybar/plugins/icon_map.sh` (`__icon_map`)
to map each app-name to its sketchybar-app-font glyph.

### 4. Sketchybar popup (sketchybarrc-defined, helper-driven)
`sketchybarrc` defines a center-anchored `switcher` anchor item, `drawing=off`
when idle (invisible in the bar) with `popup.drawing=off`. There is **no
separate plugin script** — `switcher.sh` (component 3) makes the `sketchybar
--set/--add/--remove` calls directly. Per render it rebuilds the popup children:

- One item per window: the app glyph (sketchybar-app-font); the selected item
  gets the active-pill background/color, others the surface/dim treatment
  (Tokyo Night palette, matching the existing workspace pills).
- One label item: the selected window's title.
- Toggles `switcher.popup.drawing on|off` and adds/removes the child items on
  open/render/teardown.

## Data flow

```
Karabiner (key events) ──▶ switcher.sh ──▶ sketchybar (render popup)
                               │
                               └─(commit)─▶ aerospace focus --window-id
on-focus-changed ──▶ ~/.cache/aerospace/mru   (read by switcher.sh open)
snapshot: /tmp/aerospace-switcher.state       (written open, read next/prev/commit)
```

## Edge cases

- **Empty workspace:** open draws nothing; release/commit no-op. MRU tracker
  skips (no focused window).
- **Single window:** treated as ≤1 → no popup; release no-op.
- **Window closed mid-switch:** commit's `aerospace focus --window-id` fails
  silently on a dead id; acceptable (rare; next open re-snapshots).
- **MRU history references dead windows:** pruned at read (intersect with live).
- **History file missing:** open falls back to pure window-id order.

## Files touched

- **New:** `macos/aerospace/scripts/switcher.sh` (helper — logic **and** the
  sketchybar render calls; no separate plugin).
- **Edit:** `macos/aerospace/aerospace.toml` — add `on-focus-changed`; **remove**
  `alt-tab` / `alt-shift-tab` bindings (moving to Karabiner).
- **Edit:** `macos/sketchybar/sketchybarrc` — add the `switcher` anchor item +
  popup defaults.
- **Edit:** `macos/karabiner/karabiner.json` — the state-machine rule (synced to
  dotfiles per the sync.sh drift guard).
- **Retire:** `macos/aerospace/scripts/cycle-windows.sh` (subsumed).

## Testing

- MRU tracker: focus windows in sequence, assert `~/.cache/aerospace/mru`
  records the order; assert open orders by recency.
- switcher.sh: unit-drive `open/next/prev/commit` with a stubbed window list;
  assert snapshot index math (wrap-around, MRU index-1 start) and that commit
  targets the right window-id.
- Karabiner: manual — verify open on Option+Tab, advance, reverse, Escape
  cancel, and **commit on Option release**; verify ≤1-window no-op.
- Scope: with windows on multiple workspaces, assert the popup only lists the
  focused workspace's windows.

## Non-goals

- Live window thumbnails.
- Cross-workspace switching from the popup (scope is deliberate).
- True screen-center overlay (top-center bar popup is accepted).
- Preserving `cycle-windows.sh`.
