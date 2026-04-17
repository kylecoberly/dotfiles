#!/usr/bin/env bash
# macOS setup. Sourced by ../install.sh with $DOTFILES exported.
set -euo pipefail

# ─── Homebrew ─────────────────────────────────────────────────────────
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

brew bundle --file="$DOTFILES/macos/Brewfile"

# ─── Font ─────────────────────────────────────────────────────────────
sudo cp -f "$DOTFILES/shared/fonts/Noto Mono Nerd Font Complete.ttf" /Library/Fonts/

# ─── Aerospace ────────────────────────────────────────────────────────
ln -sf "$DOTFILES/macos/aerospace/aerospace.toml" "$HOME/.aerospace.toml"

# ─── Sketchybar ───────────────────────────────────────────────────────
# Build from source; v2.17+ requires newer SDK than some Xcode versions have.
if ! command -v sketchybar >/dev/null 2>&1; then
  SB_BUILD="$(mktemp -d)"
  git clone --depth=1 --branch v2.16.4 https://github.com/FelixKratz/SketchyBar.git "$SB_BUILD/SketchyBar"
  (cd "$SB_BUILD/SketchyBar" && make)
  sudo cp "$SB_BUILD/SketchyBar/bin/sketchybar" /usr/local/bin/sketchybar
  sudo chmod +x /usr/local/bin/sketchybar
  rm -rf "$SB_BUILD"
fi

mkdir -p "$HOME/.config"
rm -rf "$HOME/.config/sketchybar"
ln -sf "$DOTFILES/macos/sketchybar" "$HOME/.config/sketchybar"

mkdir -p "$HOME/Library/LaunchAgents"
ln -sf "$DOTFILES/macos/sketchybar/org.felixkratz.sketchybar.plist" \
  "$HOME/Library/LaunchAgents/org.felixkratz.sketchybar.plist"
launchctl bootout "gui/$(id -u)/org.felixkratz.sketchybar" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/org.felixkratz.sketchybar.plist"

# ─── Karabiner ────────────────────────────────────────────────────────
mkdir -p "$HOME/.config/karabiner"
ln -sf "$DOTFILES/macos/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

# ─── Alt-Tab ──────────────────────────────────────────────────────────
ln -sf "$DOTFILES/macos/alt-tab/alt-tab.plist" \
  "$HOME/Library/Preferences/com.lwouis.alt-tab-macos.plist"

# ─── macOS defaults ───────────────────────────────────────────────────
defaults write com.apple.dock no-bouncing -bool true
defaults write com.apple.dock expose-group-apps -bool true
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
defaults write -g NSWindowResizeTime -float 0.001
defaults write com.apple.Finder AppleShowAllFiles -bool true
killall Dock 2>/dev/null || true
