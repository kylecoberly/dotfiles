#!/usr/bin/env bash
# Thin wrapper kept for muscle memory. The bare `cp` this used to run had no
# backup and no drift check, so it could silently drop the device state
# Karabiner writes into the live config (see sync.sh for the details).
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")/../karabiner" && pwd)/sync.sh" "$@"
