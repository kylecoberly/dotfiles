# Theme

Canonical palette: **Tokyo Night — Night variant**.

## How to change a color

1. Edit `palette.sh` (the only hand-maintained file).
2. Run `./theme/regenerate.sh`, then `chezmoi apply`.
3. Reload affected tools: `tmux source-file ~/.config/tmux/tmux.conf`, `sketchybar --reload`, restart Alacritty / Neovim.

## Files

- `palette.sh` — **canonical source.** Hand-maintained. Sourced directly (at `~/dotfiles/theme/palette.sh`) by:
  - `dot_config/tmux/tmux.conf` via `source-file`
  - `dot_config/sketchybar/executable_sketchybarrc` and `plugins/executable_space.sh` via `source`
- `dot_config/alacritty/palette.toml` — generated. Imported by the applied `~/.config/alacritty/alacritty.toml`.
- `palette.lua` — generated. Read by `dot_config/nvim/lua/plugins/tokyonight.lua` from `~/dotfiles/theme/palette.lua`.
- `dot_config/starship.toml` — the `[palettes.tokyonight]` block between `# >>> palette` and `# <<< palette` markers is generated; the rest of the file (format strings) is hand-maintained and references palette names like `bg:magenta` instead of hex.

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
