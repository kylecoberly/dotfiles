#!/usr/bin/env bash
# Install acsandmann/aerospace-swipe: a tiny launchd daemon that reads raw
# trackpad multitouch events and drives AeroSpace workspace switches over its
# Unix socket (/tmp/bobko.aerospace-$USER.sock) — no dependency on the
# `aerospace` binary path. Third-party compiled code, so it lives under
# ~/.local/opt rather than being vendored into this repo; the launchd plist
# `make install` writes bakes an absolute path to the built app, so the source
# must stay put. Re-runnable: updates in place and rebuilds.
set -euo pipefail

REPO="https://github.com/acsandmann/aerospace-swipe.git"
# Pinned: this commit carries the AeroSpace v0.21 socket-protocol fix (#27).
# Bump deliberately after testing a newer revision.
PIN="16aad5a5ad678335a7593a2afaa473816c278c5f"
DEST="$HOME/.local/opt/aerospace-swipe"

# Config lives in dotfiles; symlink it so `skip_empty:false` etc. survive a
# fresh install. AeroSpace's own persistent-workspaces already keeps empty
# workspaces in the keyboard next/prev cycle — this keeps the swipe daemon
# consistent with it.
mkdir -p "$HOME/.config/aerospace-swipe"
ln -sf "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/swipe-config.json" \
  "$HOME/.config/aerospace-swipe/config.json"

mkdir -p "$HOME/.local/opt"
if [[ -d "$DEST/.git" ]]; then
  git -C "$DEST" fetch --depth 1 origin "$PIN"
  git -C "$DEST" checkout -q FETCH_HEAD
else
  git clone "$REPO" "$DEST"
  git -C "$DEST" checkout -q "$PIN"
fi

# `make install` = build + codesign an app bundle with the accessibility
# entitlement + write ~/Library/LaunchAgents/com.acsandmann.swipe.plist + load.
# It unconditionally `launchctl load`s, which errors if already loaded, so
# unload first for idempotency.
launchctl unload "$HOME/Library/LaunchAgents/com.acsandmann.swipe.plist" 2>/dev/null || true
make -C "$DEST" install

echo
echo "aerospace-swipe installed. Grant Accessibility permission once:"
echo "  System Settings → Privacy & Security → Accessibility → enable AerospaceSwipe"
echo "Defaults (3-finger, wrap-around, skip-empty) need no config file; to change,"
echo "see $DEST/config.md and write ~/.config/aerospace-swipe/config.json, then:"
echo "  make -C \"$DEST\" restart"
