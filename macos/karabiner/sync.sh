#!/usr/bin/env bash
# Push the dotfiles karabiner.json to ~/.config/karabiner/. Karabiner-Elements
# watches that file via FSEvents and auto-reloads — no service restart needed.
#
# Why not symlink? Karabiner-Elements rewrites karabiner.json on every UI save
# via atomic rename, which replaces the symlink with a regular file. The only
# stable approach is a push-model copy, run on demand when the dotfiles
# version changes.
#
# Why no `launchctl kickstart`? Killing karabiner_console_user_server tears
# down the virtual HID keyboard driver; on restart macOS (and Karabiner's own
# device list) treats it as a brand-new keyboard, which means you get the
# "identify keyboard type" prompt and have to re-enable "Modify events" on
# every sync. Auto-reload via file change avoids both.

set -euo pipefail

DOTFILES_CONFIG="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/karabiner.json"
LIVE_DIR="$HOME/.config/karabiner"
LIVE_CONFIG="$LIVE_DIR/karabiner.json"

mkdir -p "$LIVE_DIR"

# No-op if live already matches dotfiles — avoids an unnecessary FSEvent.
if [[ -f "$LIVE_CONFIG" ]] && cmp -s "$DOTFILES_CONFIG" "$LIVE_CONFIG"; then
    echo "karabiner.json already in sync — nothing to do"
    exit 0
fi

if [[ -f "$LIVE_CONFIG" ]]; then
    backup="$LIVE_CONFIG.pre-sync.$(date +%Y%m%d-%H%M%S).bak"
    cp "$LIVE_CONFIG" "$backup"
    echo "backed up live config → $backup"
fi

cp "$DOTFILES_CONFIG" "$LIVE_CONFIG"
echo "copied $DOTFILES_CONFIG → $LIVE_CONFIG"
echo "karabiner will auto-reload within ~1 second (no service restart needed)"
