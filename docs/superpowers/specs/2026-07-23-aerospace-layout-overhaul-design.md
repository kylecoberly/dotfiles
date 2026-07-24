# AeroSpace / Karabiner layout overhaul

Date: 2026-07-23

## Goal

Adjust the tiling-WM setup (AeroSpace + Karabiner + sketchybar) on Apple Silicon:
pin apps to fixed workspaces, drop from 4 workspaces to 3, eliminate the
random-direction workspace-switch animation, and fix the top gap / clipped
fullscreen video.

## Context

- Canonical config lives in `~/dotfiles`:
  - `macos/aerospace/aerospace.toml` (symlinked to `~/.aerospace.toml`)
  - `macos/sketchybar/sketchybarrc` (identical to live `~/.config` copy)
  - `macos/karabiner/karabiner.json` — deployed to `~/.config/karabiner/` via
    `macos/karabiner/sync.sh` (push dotfiles → live, with backup). The live copy
    differs by ~5k lines, which is Karabiner-Elements' own reformatting, not
    hand edits.
- Single display; macOS menu bar and Dock are auto-hidden — sketchybar is the
  top bar (`height=40`, `y_offset=8`, visual bottom ≈ 48px).
- AeroSpace 0.21.3-Beta. Zen swallows the Option key, so Karabiner re-routes the
  full AeroSpace binding set to the `aerospace` CLI while Zen is focused.
- 5 native macOS Spaces currently exist (mostly spawned by native fullscreen).

## Root-cause finding

The "random direction" animation and the clipped fullscreen video are the same
underlying problem: **native macOS fullscreen** (e.g. video in Zen) puts a window
on its own native Space. AeroSpace emulates its workspaces inside a single native
Space and does not animate; but with windows scattered across 5 native Spaces,
focusing/switching forces macOS to slide between Spaces in an order unrelated to
the AeroSpace 1/2/3 numbering — hence "random." The same Space/frame contention
clips fullscreen video.

## Changes

### 1. Pin apps to workspaces (`aerospace.toml`)

`[[on-window-detected]]` rules keyed on bundle ID:

| WS | Apps (bundle id) |
|----|------------------|
| 1  | Obsidian `md.obsidian`, Todoist `com.todoist.mac.Todoist` |
| 2  | Zen `app.zen-browser.zen`, Alacritty `org.alacritty`, Finder `com.apple.finder`, Zoom `us.zoom.xos`, Moonlight `com.moonlight-stream.Moonlight` |
| 3  | Focusrite Control `com.focusrite.FocusriteControl`, Camo Studio `com.reincubate.macos.cam`, System Settings `com.apple.systempreferences` |

- Rule shape: `run = ['move-node-to-workspace N']`.
- Merge with existing rules rather than adding duplicates:
  - Finder: `run = ['layout floating', 'move-node-to-workspace 2']`
  - System Settings (`com.apple.systempreferences`): `run = ['layout floating', 'move-node-to-workspace 3']`
  - Zen: `run = ['layout tiling', 'move-node-to-workspace 2']`
- Unpinned apps keep current behavior (open on the focused workspace).
- "Settings on 3" covers **macOS System Settings only** — the generic
  title-regex `settings`/`preferences` floating rules are left as-is (still float,
  not force-moved).

### 2. Drop 4 workspaces → 3

- `aerospace.toml`: `persistent-workspaces = ["1","2","3"]`; delete `alt-4`,
  `alt-shift-4`, arrange-mode `4`, arrange-mode `ctrl-4`.
- `sketchybarrc`: both `for sid in 1 2 3 4` loops → `1 2 3`.
- `karabiner.json` (dotfiles copy): remove the Zen-scoped `workspace 4` and
  `move-node-to-workspace 4` mappings; deploy via `sync.sh`.

### 3. Animation fix

- Guided manual step: open Mission Control and delete every extra Space so
  exactly one native Space remains. (No reliable CLI exists for this.)
- Config belt-and-suspenders: `defaults write com.apple.dock
  expose-animation-duration -float 0` (approved; affects all Mission Control
  animations, reversible by deleting the key).
- Result: `alt+[` / `alt+]` switch instantly.

### 4. `alt+[` / `alt+]` wrap-around

Already correct in `aerospace.toml:56-57` and the Karabiner Zen rule
(`workspace --wrap-around prev/next`). No new work beyond #2's WS4 cleanup — the
binding was fine; the animation made it feel broken.

### 5. Top gap + fullscreen-video clip

- Tiled gap: tune `outer.top` (currently 52) to sit snug under the bar's ~48px
  visual bottom.
- Fullscreen-video clip: **test-and-confirm**. Hypothesis: resolved once Spaces
  are collapsed (#3). If it still clips, fallback (approved) is an
  `[[on-window-detected]]` rule that **floats** the browser/video fullscreen
  window so AeroSpace stops offsetting its frame and macOS handles it natively.

## Non-goals

- No refactor of the duplicated `main`/`arrange` mode bindings or the
  Karabiner-mirrors-AeroSpace-for-Zen structure. They exist for real reasons
  (Zen eats Option). Reviewed, intentionally left alone.

## Order of work & verification

1. Edit `aerospace.toml` (pins, 3-workspace, `outer.top`).
2. Edit `sketchybarrc` (loops → `1 2 3`).
3. Edit dotfiles `karabiner.json` (remove WS4); run `sync.sh`.
4. `aerospace reload-config`; restart sketchybar.
5. Guided Space collapse + `expose-animation-duration` default.
6. Verify: pins land correctly, switching is instant, no stray WS4, top gap
   snug, fullscreen video not clipped.
7. Only if step 6 shows clipping: add the float fallback (#5) and re-verify.

## Risks

- Karabiner `sync.sh` overwrites live with the dotfiles copy. Before syncing,
  confirm the live copy has no semantic rules the dotfiles copy lacks (the big
  diff is expected reformatting, but verify the aerospace/bracket rules match).
- `expose-animation-duration = 0` speeds up all Mission Control animations
  (accepted).
