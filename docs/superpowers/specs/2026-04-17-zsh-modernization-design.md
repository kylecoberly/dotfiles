# Zsh Modernization Design

**Date:** 2026-04-17
**Status:** Approved, pending implementation plan

## Goal

Modernize Kyle's long-standing zsh configuration to be lean, current, and aligned with 2025-era tooling while preserving Unix power-user ergonomics. Speed improvements are welcome but are a secondary benefit; the primary goal is reducing dependencies and picking tools with active momentum.

## Non-Goals

- Switching shells (fish, nushell) — breaks POSIX muscle memory
- Cross-machine history sync (atuin) — not requested, adds complexity
- Refactoring tmux or nvim configs — out of scope
- Restructuring `apps/.aliases` beyond redundancy with new tools

## Current State (to be replaced)

- **Framework:** oh-my-zsh with 14 plugins
- **Theme:** `coberly-gruvbox.zsh-theme` — 279-line custom Powerline fork of agnoster. Shells out to `git status --porcelain` and `git rev-list` on every prompt redraw.
- **Plugin install:** `install.sh` manually `git clone`s zsh-autosuggestions, zsh-syntax-highlighting, and (unused) powerlevel10k into `~/.oh-my-zsh/custom/plugins/`.
- **Version manager:** asdf with Java + Golang plugins, sourced from `.zshrc`.
- **PATH:** Contains Linux holdovers (`/root/bin`, `/snap/bin`, `/usr/games`, `/usr/local/heroku/bin`, `/usr/bin/gradle-6.6.1/bin`, `/root/.config/composer/vendor/bin`).
- **Bindings:** `bindkey -v` with `jj`/`jk` → cmd mode; `^R` history search; `Esc-.` insert-last-word.
- **Aliases:** Sourced from `~/.aliases` (symlinked from `dotfiles/apps/.aliases`, 27 lines).

## New Architecture

### Layers

1. **zsh** — unchanged
2. **Native zsh config** — options, bindings, vi-mode configured directly (no framework)
3. **Plugins (direct `source`)** — 3 plugins cloned to `~/.zsh/plugins/`:
   - `zsh-autosuggestions`
   - `zsh-syntax-highlighting`
   - `fzf-tab`
4. **Prompt** — Starship, initialized via `eval "$(starship init zsh)"`
5. **Runtime manager** — mise, initialized via `eval "$(mise activate zsh)"`
6. **Modern CLI tools** — fzf, zoxide, eza, bat, ripgrep, delta (installed via Homebrew; integrated via shell hooks + aliases + git config)

### File Layout

```
dotfiles/zsh/
├── .zshrc                    # ~60 lines, sectioned
├── aliases.zsh               # eza/bat aliases + git shortcuts migrated from OMZ `git` plugin
├── install.sh                # brew installs + plugin clones + symlinks
└── starship.toml             # prompt config (gruvbox palette)
```

### Files removed

- `dotfiles/zsh/coberly-gruvbox.zsh-theme` (replaced by `starship.toml`)
- `~/.oh-my-zsh/` (entire oh-my-zsh install, ~50MB)
- Powerlevel10k clone (was cloned but never used)

### `.zshrc` section order

1. **Options** — `extendedglob`, `nocaseglob`, `globdots`; history size/dedup settings; `VISUAL`/`EDITOR` = nvim
2. **PATH** — macOS-focused; drops Linux holdovers; keeps Homebrew, `~/.local/bin`, `~/.cargo/bin`, `~/.fly/bin`
3. **Bindings** — `bindkey -v`; `jj`/`jk` → cmd mode; `^R` history; `Esc-.` insert-last-word
4. **Plugins** — `source` the 3 plugins (order matters: syntax-highlighting must be last)
5. **Tool init** — in this order:
   - `eval "$(starship init zsh)"`
   - `eval "$(mise activate zsh)"`
   - `eval "$(zoxide init zsh)"`
   - `eval "$(fzf --zsh)"` (keybindings + completion; does NOT hijack `^R` unless opted in)
6. **Aliases** — `source` `aliases.zsh` and `~/.aliases`
7. **Misc** — colored man pages via `LESS_TERMCAP_*` exports (~5 lines, replaces `colored-man-pages` OMZ plugin)

### Keybindings

- vi-mode (`bindkey -v`)
- `jj` / `jk` → normal mode (viins)
- `^R` → fzf fuzzy history search (via `fzf --zsh` default binding — replaces native history-incremental-search)
- `^T` → fzf file picker (fzf default)
- `Alt-C` → fzf directory picker + cd (fzf default)
- `Esc-.` → insert-last-word

### Prompt (starship.toml)

Mimics current segments in order: OS icon → directory → git branch + status. Uses gruvbox palette (`#fabd2f` yellow, `#83a598` blue, `#b8bb26` green, `#fb4934` red) to preserve visual identity. Async git by default — no more synchronous `git status --porcelain` on every render.

### Plugins replacement mapping

| Removed OMZ plugin | Replacement |
|--------------------|-------------|
| `git` | ~40 lines of aliases in `aliases.zsh` (only the ones Kyle uses) |
| `git-extras` | Drop — not used |
| `command-not-found` | macOS Homebrew provides this natively |
| `common-aliases` | Drop — most conflict with eza/bat preferences |
| `npm` | Drop — not used |
| `tmux` | Drop — tmux is launched/used directly, not via OMZ |
| `vi-mode` | Native `bindkey -v` (already configured) |
| `sudo` | Drop — not used |
| `ubuntu` | Drop — macOS-only now |
| `docker-compose` | Drop — not used |
| `asdf` | Replaced by mise |
| `copyfile` | Drop — not used |
| `history` | Drop — native history settings in `.zshrc` |
| `colored-man-pages` | 5-line `LESS_TERMCAP_*` snippet |
| `fancy-ctrl-z` | Drop — not used |

### Version manager migration (asdf → mise)

- Install: `brew install mise`
- Tools: `mise use -g` for previously-global asdf tools; project-level `.tool-versions` files work unchanged
- Remove asdf sourcing block from `.zshrc`
- Uninstall asdf after verification

### Modern CLI tools integration

| Tool | Integration |
|------|-------------|
| `fzf` | `eval "$(fzf --zsh)"` — fuzzy `^R` history, `^T` files, `Alt-C` dirs |
| `fzf-tab` | Sourced as plugin — fuzzy tab-completion menus |
| `zoxide` | `eval "$(zoxide init zsh)"` — adds `z` command |
| `eza` | `alias ls='eza'`, `alias ll='eza -l --git'`, `alias la='eza -la --git'`, `alias lt='eza --tree'` |
| `bat` | `alias cat='bat --plain'` (plain by default; use `bat` explicitly for syntax highlighting) |
| `ripgrep` | No alias (already using `rg`); consider `alias grep='rg'` if desired |
| `delta` | Configured in `~/.gitconfig` as pager (not shell-level) |

## Migration Strategy

1. **Phase 1 — Install new tools** (non-destructive, additive):
   - `brew install starship mise fzf zoxide eza bat ripgrep git-delta`
   - Clone the 3 zsh plugins to `~/.zsh/plugins/`
2. **Phase 2 — Write new config in parallel:**
   - Write new `.zshrc`, `aliases.zsh`, `starship.toml` to `dotfiles/zsh/`
   - Test in a scratch shell: `ZDOTDIR=/tmp/newzsh zsh`
3. **Phase 3 — Cut over:**
   - Update `dotfiles/zsh/install.sh` (new symlinks, brew installs, plugin clones)
   - Re-run `install.sh`
   - Open a new shell; verify prompt, bindings, plugins, mise, CLI tools
4. **Phase 4 — Clean up:**
   - `rm -rf ~/.oh-my-zsh`
   - `asdf plugin list` → reinstall equivalents in mise → `rm -rf ~/.asdf`
   - Delete `dotfiles/zsh/coberly-gruvbox.zsh-theme`
5. **Rollback:** Git history contains everything; `git revert` is a one-liner.

## Success Criteria

- New shell opens without oh-my-zsh present on disk
- Prompt renders with starship showing OS icon, dir, git branch + async status
- `jj`/`jk` still exits to vi cmd mode; `^R` opens fzf fuzzy history
- `mise ls` shows previously-asdf-managed tools
- `z dotfiles` jumps to `~/dotfiles`; `ls` uses eza; `cat foo.js` shows plain file
- Tab-completing `cd <TAB>` shows an fzf picker
- No broken references to oh-my-zsh, asdf, or the old theme in any dotfile
