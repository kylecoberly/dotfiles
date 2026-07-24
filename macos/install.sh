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

# ─── Claude Code ──────────────────────────────────────────────────────
# Native installer puts the binary under ~/.local/share/claude/versions/
# and self-updates in the background. Not using the Homebrew cask so
# updates don't require `brew upgrade`.
if ! command -v claude >/dev/null 2>&1; then
  curl -fsSL https://claude.ai/install.sh | bash
fi

# ─── Font ─────────────────────────────────────────────────────────────
# Per-user install — no sudo needed, and every GUI app still finds it.
mkdir -p "$HOME/Library/Fonts"
cp -f "$DOTFILES/shared/fonts/Noto Mono Nerd Font Complete.ttf" "$HOME/Library/Fonts/"

# ─── Aerospace ────────────────────────────────────────────────────────
ln -sf "$DOTFILES/macos/aerospace/aerospace.toml" "$HOME/.aerospace.toml"

# Trackpad-swipe workspace switching. Builds a launchd daemon into
# ~/.local/opt; needs a one-time Accessibility grant (script prints how).
"$DOTFILES/macos/aerospace/install-swipe.sh"

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
link_dir "$DOTFILES/macos/sketchybar" "$HOME/.config/sketchybar"

mkdir -p "$HOME/Library/LaunchAgents"
ln -sf "$DOTFILES/macos/sketchybar/org.felixkratz.sketchybar.plist" \
  "$HOME/Library/LaunchAgents/org.felixkratz.sketchybar.plist"
launchctl bootout "gui/$(id -u)/org.felixkratz.sketchybar" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/org.felixkratz.sketchybar.plist"

# ─── Peon-ping relay ──────────────────────────────────────────────────
# LaunchAgent runs `peon relay` in the foreground (no --daemon — launchd
# manages the process). KeepAlive only on crash so `peon relay --stop`
# still works. Plist is templated for the local brew prefix — install-relay.sh
# re-resolves it independently so it's also safe to re-run standalone (e.g.
# over SSH) after a Homebrew prefix change breaks the relay.
if command -v peon >/dev/null 2>&1; then
  "$DOTFILES/macos/peon/install-relay.sh"
fi

# ─── Karabiner ────────────────────────────────────────────────────────
# Karabiner-Elements rewrites karabiner.json on UI saves (atomic rename),
# so a symlink can't hold. Push the dotfiles version + restart the service.
# Run "$DOTFILES/macos/karabiner/sync.sh" after editing karabiner.json.
"$DOTFILES/macos/karabiner/sync.sh"

# ─── macOS defaults ───────────────────────────────────────────────────
defaults write com.apple.dock no-bouncing -bool true
defaults write com.apple.dock expose-group-apps -bool true
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
defaults write -g NSWindowResizeTime -float 0.001
defaults write com.apple.Finder AppleShowAllFiles -bool true
# Disable the native 3-finger horizontal Spaces swipe — under AeroSpace's
# single-Space model it only fights aerospace-swipe when a fullscreen app has
# created a real Space. 4-finger horizontal stays bound to native Spaces.
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0
killall Dock 2>/dev/null || true
