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

# Karabiner writes two things into the live config that no dotfiles edit can
# reproduce: `devices` (populated when you answer the "identify keyboard type"
# prompt for a new keyboard) and `virtual_hid_keyboard.keyboard_type_v2`.
# Copying over them re-triggers that prompt and drops the per-device settings,
# which is exactly the breakage this script's header is trying to avoid. Refuse
# to sync until they've been ported back into the dotfiles copy.
if [[ -f "$LIVE_CONFIG" ]]; then
    python3 - "$DOTFILES_CONFIG" "$LIVE_CONFIG" <<'PY' || exit 1
import json, sys

dot, live = (json.load(open(p))['profiles'][0] for p in sys.argv[1:3])
drift = []

if live.get('devices') and live.get('devices') != dot.get('devices'):
    drift.append(f"  devices: live has {json.dumps(live['devices'])}, dotfiles has {json.dumps(dot.get('devices'))}")

lk = live.get('virtual_hid_keyboard', {}).get('keyboard_type_v2')
if lk and lk != dot.get('virtual_hid_keyboard', {}).get('keyboard_type_v2'):
    drift.append(f"  virtual_hid_keyboard.keyboard_type_v2: live has {lk!r}, dotfiles has none")

if drift:
    print('refusing to sync — live config has device state the dotfiles copy would drop:')
    print('\n'.join(drift))
    print('\nPort these into macos/karabiner/karabiner.json, then re-run.')
    sys.exit(1)
PY

    backup="$LIVE_CONFIG.pre-sync.$(date +%Y%m%d-%H%M%S).bak"
    cp "$LIVE_CONFIG" "$backup"
    echo "backed up live config → $backup"
fi

cp "$DOTFILES_CONFIG" "$LIVE_CONFIG"
echo "copied $DOTFILES_CONFIG → $LIVE_CONFIG"
echo "karabiner will auto-reload within ~1 second (no service restart needed)"
