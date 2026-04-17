# Theme

Canonical palette: **Tokyo Night — Night variant**.

## How to change a color

1. Edit `palette.sh` (the only hand-maintained file).
2. Run `./theme/regenerate.sh`.
3. Reload affected tools: `tmux source-file ~/dotfiles/shared/tmux/tmux.conf.local`, `sketchybar --reload`, restart Alacritty / Neovim.

## Files

- `palette.sh` — **canonical source.** Hand-maintained. Sourced directly by:
  - `shared/tmux/tmux.conf.local` via `source-file`
  - `macos/sketchybar/sketchybarrc` and `plugins/space.sh` via `source`
- `palette.toml` — generated. Imported by `shared/alacritty/alacritty.toml`.
- `palette.lua` — generated. Available to Neovim (tokyonight.nvim has its own; this is for ad-hoc lua references).
- `shared/zsh/starship.toml` — the `[palettes.tokyonight]` block between `# >>> palette` and `# <<< palette` markers is generated; the rest of the file (format strings) is hand-maintained and references palette names like `bg:magenta` instead of hex.

`regenerate.sh` overwrites the three generated targets from `palette.sh`. Don't edit them by hand — changes will be lost on the next regen.

## Consumers with no source-of-truth coupling

- Neovim uses `tokyonight.nvim`, which ships its own palette internally — `palette.lua` is unused unless you reference it explicitly.

## Naming notes

- `magenta` (#bb9af7) is the bright purple-ish accent used by most tools. This is what folke/tokyonight.nvim calls `magenta` and what most TN terminal ports call "purple" colloquially.
- `purple` (#9d7cd8) is the deeper violet used more rarely. Distinct from `magenta`.
- `blue0` (#3d59a1) is TN's deep sapphire used for the starship directory segment.

## Out of scope

- Chrome browser chrome is themed via a Tokyo Night extension from the Chrome Web Store — not managed here.
- Aerospace has no color config of its own; its visible status bar is sketchybar.
