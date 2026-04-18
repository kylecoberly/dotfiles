#!/usr/bin/env bash
# Cross-platform setup. Sourced by ../install.sh with $DOTFILES exported.
set -euo pipefail

# ─── Helpers ──────────────────────────────────────────────────────────
# Replace $dest with a symlink to $src. If $dest is already a symlink, just
# redirect it. If it's a real file/dir, move it to a timestamped backup so
# we never silently clobber user data. Available to sourced platform scripts.
DOTFILES_BACKUP_DIR="$HOME/.dotfiles-backup/install-$(date +%Y%m%d-%H%M%S)"
link_dir() {
  local src="$1" dest="$2"
  if [ -L "$dest" ]; then
    rm "$dest"
  elif [ -e "$dest" ]; then
    mkdir -p "$DOTFILES_BACKUP_DIR"
    mv "$dest" "$DOTFILES_BACKUP_DIR/$(basename "$dest")"
    echo "  backed up $dest → $DOTFILES_BACKUP_DIR/"
  fi
  ln -s "$src" "$dest"
}

# ─── Git dotfiles ─────────────────────────────────────────────────────
for f in .gitconfig .gitignore; do
  ln -sf "$DOTFILES/shared/git/$f" "$HOME/$f"
done

# ─── Zsh ──────────────────────────────────────────────────────────────
ln -sf "$DOTFILES/shared/zsh/.zshrc" "$HOME/.zshrc"
mkdir -p "$HOME/.config"
ln -sf "$DOTFILES/shared/zsh/starship.toml" "$HOME/.config/starship.toml"

PLUGIN_DIR="$HOME/.zsh/plugins"
mkdir -p "$PLUGIN_DIR"
clone_if_missing() {
  [ -d "$2" ] || git clone --depth=1 "$1" "$2"
}
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions     "$PLUGIN_DIR/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting "$PLUGIN_DIR/zsh-syntax-highlighting"
clone_if_missing https://github.com/Aloxaf/fzf-tab                    "$PLUGIN_DIR/fzf-tab"

# ─── Tmux ─────────────────────────────────────────────────────────────
link_dir "$DOTFILES/shared/tmux" "$HOME/.config/tmux"

# ─── Neovim ───────────────────────────────────────────────────────────
link_dir "$DOTFILES/shared/nvim" "$HOME/.config/nvim"

# ─── Alacritty (cross-platform config) ────────────────────────────────
mkdir -p "$HOME/.config/alacritty"
ln -sf "$DOTFILES/shared/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

# ─── mise ─────────────────────────────────────────────────────────────
ln -sf "$DOTFILES/shared/mise/.asdfrc"       "$HOME/.asdfrc"
ln -sf "$DOTFILES/shared/mise/.tool-versions" "$HOME/.tool-versions"

# ─── Claude Code ──────────────────────────────────────────────────────
CLAUDE_SRC="$DOTFILES/shared/claude"
CLAUDE_DEST="$HOME/.claude"
mkdir -p "$CLAUDE_DEST"
BACKUP_DIR="$CLAUDE_DEST/backups/install-$(date +%Y%m%d-%H%M%S)"
claude_link() {
  local name="$1"
  local src="$CLAUDE_SRC/$name"
  local dest="$CLAUDE_DEST/$name"
  [ -e "$src" ] || return 0
  if [ -L "$dest" ]; then
    rm "$dest"
  elif [ -e "$dest" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dest" "$BACKUP_DIR/$name"
  fi
  ln -s "$src" "$dest"
}
for item in settings.json CLAUDE.md statusline-command.sh commands agents skills; do
  claude_link "$item"
done
