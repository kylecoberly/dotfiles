#!/usr/bin/env bash
# Installs/repairs the peon-ping relay LaunchAgent. Self-contained: resolves
# the Homebrew prefix itself rather than trusting the caller's PATH, so it
# works from a plain non-interactive SSH command (`ssh mac 'dotfiles/macos/peon/install-relay.sh'`)
# and not just when sourced from install.sh inside an interactive shell.
#
# Re-run this any time `peon relay` is dead in `launchctl list` — the usual
# cause is `peon` moving Homebrew prefix (Intel /usr/local vs Apple Silicon
# /opt/homebrew) out from under the plist's hardcoded binary path.
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if ! command -v peon >/dev/null 2>&1; then
  echo "install-relay.sh: 'peon' not found (checked PATH after brew shellenv)" >&2
  echo "  Install it first: brew install peon-ping" >&2
  exit 1
fi

PEON_BIN="$(command -v peon)"
PEON_PLIST="$HOME/Library/LaunchAgents/com.peon-ping.relay.plist"

mkdir -p "$HOME/Library/LaunchAgents"
sed -e "s|__PEON_BIN__|$PEON_BIN|g" -e "s|__HOME__|$HOME|g" \
  "$DOTFILES/macos/peon/com.peon-ping.relay.plist" > "$PEON_PLIST"

launchctl bootout "gui/$(id -u)/com.peon-ping.relay" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$PEON_PLIST"

echo "peon-ping relay installed: $PEON_BIN"
