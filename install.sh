#!/usr/bin/env bash
# Top-level entrypoint. Runs shared setup, then the platform-specific script.
set -euo pipefail

if [ -z "${HOME:-}" ]; then
  echo "HOME not set" >&2
  exit 1
fi

if [ "${CODESPACES:-}" = "true" ]; then
  DOTFILES="/workspaces/.codespaces/.persistedshare/dotfiles"
else
  DOTFILES="${HOME}/dotfiles"
fi
export DOTFILES

echo "→ shared configuration"
source "$DOTFILES/shared/install.sh"

case "$OSTYPE" in
  darwin*)
    echo "→ macOS configuration"
    source "$DOTFILES/macos/install.sh"
    ;;
  linux-gnu*)
    echo "→ Linux configuration"
    source "$DOTFILES/linux/install.sh"
    ;;
  *)
    echo "Unknown OSTYPE: $OSTYPE — skipping platform install" >&2
    ;;
esac

echo "✓ Ready to go"
