#!/usr/bin/env bash
# Push the dotfiles Alt-Tab plist into ~/Library/Preferences and force
# cfprefsd + Alt-Tab to re-read it.
#
# Why not symlink? cfprefsd rewrites plists via atomic rename when the
# app saves settings, which replaces a symlink with a regular file. Same
# failure mode as Karabiner.
#
# Why the bounce? cfprefsd caches plists aggressively; writing to the
# file on disk alone doesn't guarantee the running domain updates.
# Killing cfprefsd + Alt-Tab is the reliable path.

set -euo pipefail

DOTFILES_PLIST="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/alt-tab.plist"
LIVE_PLIST="$HOME/Library/Preferences/com.lwouis.alt-tab-macos.plist"

if [[ -f "$LIVE_PLIST" && ! -L "$LIVE_PLIST" ]] && cmp -s "$DOTFILES_PLIST" "$LIVE_PLIST"; then
    echo "alt-tab.plist already in sync — nothing to do"
    exit 0
fi

# Stop Alt-Tab before touching its plist so it doesn't flush stale
# in-memory state over our fresh copy when it exits.
pkill -x "AltTab" 2>/dev/null || true
sleep 0.3

if [[ -e "$LIVE_PLIST" || -L "$LIVE_PLIST" ]]; then
    backup="$LIVE_PLIST.pre-sync.$(date +%Y%m%d-%H%M%S).bak"
    cp -L "$LIVE_PLIST" "$backup" 2>/dev/null || true
    rm -f "$LIVE_PLIST"
    echo "backed up live plist → $backup"
fi

cp "$DOTFILES_PLIST" "$LIVE_PLIST"
echo "copied $DOTFILES_PLIST → $LIVE_PLIST"

# Flush cfprefsd's cache for this domain.
killall cfprefsd 2>/dev/null || true

# Relaunch Alt-Tab so it picks up the new settings.
open -a AltTab 2>/dev/null || echo "AltTab.app not found — open Alt-Tab manually"
echo "done"
