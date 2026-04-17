#!/bin/bash
set -eu

if [ -z "$HOME" ]; then
  exit 1
fi

if [ "${CODESPACES:-}" = "true" ]; then
  DOTFILE_DIRECTORY="/workspaces/.codespaces/.persistedshare/dotfiles"
else
  DOTFILE_DIRECTORY="${HOME}/dotfiles"
fi

# Homebrew packages
BREW_PKGS=(starship mise fzf zoxide eza bat ripgrep git-delta)
if command -v brew >/dev/null 2>&1; then
  for pkg in "${BREW_PKGS[@]}"; do
    brew list "$pkg" >/dev/null 2>&1 || brew install "$pkg"
  done
fi

# Zsh plugins
PLUGIN_DIR="$HOME/.zsh/plugins"
mkdir -p "$PLUGIN_DIR"
clone_if_missing() {
  local repo="$1"
  local dir="$2"
  if [ ! -d "$dir" ]; then
    git clone --depth=1 "$repo" "$dir"
  fi
}
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions       "$PLUGIN_DIR/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting   "$PLUGIN_DIR/zsh-syntax-highlighting"
clone_if_missing https://github.com/Aloxaf/fzf-tab                      "$PLUGIN_DIR/fzf-tab"

# Starship config
mkdir -p "${HOME}/.config"
ln -sf "${DOTFILE_DIRECTORY}/zsh/starship.toml" "${HOME}/.config/starship.toml"

# zshrc symlink
rm -f "${HOME}/.zshrc"
ln -sf "${DOTFILE_DIRECTORY}/zsh/.zshrc" "${HOME}/.zshrc"
