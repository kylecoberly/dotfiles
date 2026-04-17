#!/usr/bin/env bash
# Linux (Ubuntu/Debian) setup. Sourced by ../install.sh with $DOTFILES exported.
set -euo pipefail

sudo apt-get update

# ─── Third-party apt repos ────────────────────────────────────────────
if ! dpkg -s 1password-cli >/dev/null 2>&1; then
  curl -sS https://downloads.1password.com/linux/keys/1password.asc |
    sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' |
    sudo tee /etc/apt/sources.list.d/1password.list
fi

if ! dpkg -s code >/dev/null 2>&1; then
  curl -sS https://packages.microsoft.com/keys/microsoft.asc |
    sudo gpg --dearmor --output /usr/share/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |
    sudo tee /etc/apt/sources.list.d/vscode.list
fi

if ! dpkg -s google-chrome-stable >/dev/null 2>&1; then
  curl -sS https://dl.google.com/linux/linux_signing_key.pub |
    sudo gpg --dearmor --output /usr/share/keyrings/google-chrome.gpg
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main' |
    sudo tee /etc/apt/sources.list.d/google-chrome.list
fi

sudo apt-get update

# ─── apt packages (comments + blank lines stripped) ───────────────────
grep -v '^\s*#' "$DOTFILES/linux/packages.txt" | grep -v '^\s*$' |
  xargs sudo apt-get install -y --no-install-recommends

# ─── Tools not in apt ─────────────────────────────────────────────────
if ! command -v mise >/dev/null 2>&1; then
  curl https://mise.run | sh
fi

if ! command -v starship >/dev/null 2>&1; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

if ! command -v flyctl >/dev/null 2>&1; then
  curl -L https://fly.io/install.sh | sh
fi

if ! command -v just >/dev/null 2>&1; then
  mkdir -p "$HOME/.local/bin"
  curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh |
    bash -s -- --to "$HOME/.local/bin"
fi

# ─── Font ─────────────────────────────────────────────────────────────
mkdir -p "$HOME/.local/share/fonts"
cp -f "$DOTFILES/shared/fonts/Noto Mono Nerd Font Complete.ttf" "$HOME/.local/share/fonts/"
fc-cache -f

# ─── Alacritty desktop integration ────────────────────────────────────
if [ -d /etc/X11/xorg.conf.d ]; then
  sudo cp -f "$DOTFILES/linux/alacritty/40-libinput.conf" /etc/X11/xorg.conf.d/40-libinput.conf
fi
if [ -d /usr/share/applications ]; then
  sudo cp -f "$DOTFILES/linux/alacritty/Alacritty.desktop" /usr/share/applications/
fi
