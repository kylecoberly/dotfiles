#!/usr/bin/env bash
# Linux (Ubuntu/Debian) setup. Sourced by ../install.sh with $DOTFILES exported.
set -euo pipefail

sudo apt-get update

# add-apt-repository needed for the alacritty PPA below
if ! command -v add-apt-repository >/dev/null 2>&1; then
  sudo apt-get install -y software-properties-common
fi

# ─── Third-party apt repos ────────────────────────────────────────────
# Ubuntu's apt alacritty lags upstream by 1-2 versions; the maintainer's
# PPA tracks current releases (needed for [general] config section).
if ! grep -rq aslatter /etc/apt/sources.list.d/ 2>/dev/null; then
  sudo add-apt-repository -y ppa:aslatter/ppa
fi

if [ ! -f /usr/share/keyrings/1password-archive-keyring.gpg ]; then
  curl -sS https://downloads.1password.com/linux/keys/1password.asc |
    sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' |
    sudo tee /etc/apt/sources.list.d/1password.list
fi

if [ ! -f /usr/share/keyrings/packages.microsoft.gpg ]; then
  curl -sS https://packages.microsoft.com/keys/microsoft.asc |
    sudo gpg --dearmor --output /usr/share/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |
    sudo tee /etc/apt/sources.list.d/vscode.list
fi

if [ ! -f /usr/share/keyrings/google-chrome.gpg ]; then
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

if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sh
fi

if ! command -v aws >/dev/null 2>&1; then
  curl -sS "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
  unzip -qo /tmp/awscliv2.zip -d /tmp
  sudo /tmp/aws/install
  rm -rf /tmp/awscliv2.zip /tmp/aws
fi

# Ubuntu apt fzf (0.44) predates `fzf --zsh` shell integration (0.48+)
if ! command -v fzf >/dev/null 2>&1 || ! fzf --zsh >/dev/null 2>&1; then
  FZF_VERSION=0.56.3
  mkdir -p "$HOME/.local/bin"
  curl -fsSL "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz" |
    tar -xz -C "$HOME/.local/bin"
fi

if ! command -v just >/dev/null 2>&1; then
  mkdir -p "$HOME/.local/bin"
  curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh |
    bash -s -- --to "$HOME/.local/bin"
fi

# Claude Code — same native installer as macOS; ~/.local/share/claude/...
if ! command -v claude >/dev/null 2>&1; then
  curl -fsSL https://claude.ai/install.sh | bash
fi

# peon-ping — voice + overlay notifications for Claude Code.
# Installs binary, default sound packs, and registers the hook at
# ~/.claude/hooks/peon-ping/. ffmpeg (already in packages.txt) is needed
# for non-WAV pack formats.
if ! command -v peon >/dev/null 2>&1; then
  curl -fsSL https://raw.githubusercontent.com/PeonPing/peon-ping/main/install.sh | bash
fi

# Obsidian and Zoom ship only as .deb downloads — no apt repo.
if ! command -v obsidian >/dev/null 2>&1; then
  OBSIDIAN_DEB_URL=$(curl -fsSL https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest |
    jq -r '.assets[] | select(.name | test("^obsidian_[0-9.]+_amd64\\.deb$")) | .browser_download_url')
  curl -fsSL "$OBSIDIAN_DEB_URL" -o /tmp/obsidian.deb
  sudo apt-get install -y /tmp/obsidian.deb
  rm /tmp/obsidian.deb
fi

if ! command -v zoom >/dev/null 2>&1; then
  curl -fsSL https://zoom.us/client/latest/zoom_amd64.deb -o /tmp/zoom.deb
  sudo apt-get install -y /tmp/zoom.deb
  rm /tmp/zoom.deb
fi

# Zen Browser ships only as a tarball on Linux — no apt repo, no .deb.
if ! command -v zen >/dev/null 2>&1; then
  ZEN_TARBALL_URL=$(curl -fsSL https://api.github.com/repos/zen-browser/desktop/releases/latest |
    jq -r '.assets[] | select(.name == "zen.linux-x86_64.tar.xz") | .browser_download_url')
  curl -fsSL "$ZEN_TARBALL_URL" -o /tmp/zen.tar.xz
  sudo rm -rf /opt/zen
  sudo tar -xJf /tmp/zen.tar.xz -C /opt
  sudo ln -sf /opt/zen/zen /usr/local/bin/zen
  sudo tee /usr/share/applications/zen.desktop >/dev/null <<'EOF'
[Desktop Entry]
Name=Zen Browser
GenericName=Web Browser
Exec=/opt/zen/zen %u
Icon=/opt/zen/browser/chrome/icons/default/default128.png
Terminal=false
Type=Application
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
Categories=Network;WebBrowser;
StartupWMClass=zen
EOF
  rm /tmp/zen.tar.xz
fi

# ─── Font ─────────────────────────────────────────────────────────────
mkdir -p "$HOME/.local/share/fonts"
cp -f "$DOTFILES/shared/fonts/Noto Mono Nerd Font Complete.ttf" "$HOME/.local/share/fonts/"
fc-cache -f

# ─── GNOME keybindings ────────────────────────────────────────────────
# Alt+N → workspace N. GNOME default is Shift+Ctrl+N (and only for odd
# numbers on this box, for reasons lost to history).
if command -v gsettings >/dev/null 2>&1; then
  for i in 1 2 3 4; do
    gsettings set org.gnome.desktop.wm.keybindings \
      "switch-to-workspace-$i" "['<Alt>$i']"
  done
fi

# ─── Alacritty desktop integration ────────────────────────────────────
if [ -d /etc/X11/xorg.conf.d ]; then
  sudo rm -f /etc/X11/xorg.conf.d/40-libinput.conf
  sudo cp "$DOTFILES/linux/alacritty/40-libinput.conf" /etc/X11/xorg.conf.d/40-libinput.conf
fi
# The PPA package ships com.alacritty.Alacritty.desktop, so remove the stale
# bare-name copy that older runs of this script installed.
sudo rm -f /usr/share/applications/Alacritty.desktop
