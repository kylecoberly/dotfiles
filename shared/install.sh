#!/usr/bin/env bash
# Cross-platform setup. Sourced by ../install.sh with $DOTFILES exported.
set -euo pipefail

# ─── Git dotfiles ─────────────────────────────────────────────────────
for f in .gitconfig .gitignore .aliases; do
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
rm -rf "$HOME/.config/tmux"
ln -sf "$DOTFILES/shared/tmux" "$HOME/.config/tmux"

# ─── Neovim ───────────────────────────────────────────────────────────
rm -rf "$HOME/.config/nvim"
ln -sf "$DOTFILES/shared/nvim" "$HOME/.config/nvim"

# ─── Alacritty (cross-platform config) ────────────────────────────────
mkdir -p "$HOME/.config/alacritty"
ln -sf "$DOTFILES/shared/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
ln -sf "$DOTFILES/shared/alacritty/melange.toml"   "$HOME/.config/alacritty/melange.toml"

# ─── mise ─────────────────────────────────────────────────────────────
# mise reads ~/.tool-versions automatically. To set globals:
#   mise use -g node@lts ruby@3.3 python@3.12
ln -sf "$DOTFILES/shared/mise/.asdfrc" "$HOME/.asdfrc"

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
