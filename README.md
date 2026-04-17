# Kyle Coberly's dotfiles

## Install

```sh
git clone https://github.com/kylecoberly/dotfiles ~/dotfiles
cd ~/dotfiles && ./install.sh
```

The root `install.sh` sources `shared/install.sh` then the matching platform script (`macos/install.sh` or `linux/install.sh`). Each sub-script is also runnable on its own.

## Layout

```
dotfiles/
├── install.sh          # OS-detecting entrypoint
├── theme/              # Tokyo Night palette — canonical source + regenerator
├── shared/             # cross-platform: nvim, zsh, tmux, alacritty, git, mise, claude
├── macos/              # aerospace, sketchybar, karabiner, alt-tab + Brewfile
└── linux/              # Ubuntu alacritty desktop integration + apt packages.txt
```

## Theme

Tokyo Night palette lives in `theme/`. Edit `theme/palette.sh`, then run
`./theme/regenerate.sh` to update `palette.toml`, `palette.lua`, and the
generated block in `shared/zsh/starship.toml`. See `theme/README.md`.

## Package management

- **macOS**: `macos/Brewfile` is the declarative source of truth. Install with
  `brew bundle --file=macos/Brewfile`; prune unlisted with `brew bundle cleanup`.
- **Linux**: `linux/packages.txt` is the apt list. Third-party repos (1Password,
  VS Code, Chrome) are added by `linux/install.sh`, and tools without apt
  packages (`mise`, `starship`, `flyctl`, `just`) are installed by curl scripts
  in the same file.

## History

This repo previously had a NixOS configuration under `nixos/` and an i3/polybar
Linux WM stack under `window-manager/ubuntu/`. Both were removed — see git
history for the prior declarative package manifest.
